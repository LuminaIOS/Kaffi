//
//
//

import AVFoundation
import Speech
import Combine

@MainActor
class MicRecognizer: NSObject, ObservableObject {
    @Published var transcript = ""
    @Published var isRecording = false

    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "es-MX"))
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    func start() throws {
        Task {
            await startListening()
        }
    }

    func stop() {
        stopListening()
    }

    func startListening() async {
        #if targetEnvironment(simulator)
        print("Mic disabled in Simulator")
        #else
        let granted = await requestPermissions()
        guard granted else {
            print("Mic or Speech recognition permission denied")
            return
        }

        do {
            stopListening()

            transcript = ""
            isRecording = true

            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

            request = SFSpeechAudioBufferRecognitionRequest()
            request?.shouldReportPartialResults = true
            request?.requiresOnDeviceRecognition = false  // Use cloud recognition for better accuracy

            if #available(iOS 13, *) {
                request?.taskHint = .dictation
            }

            let inputNode = audioEngine.inputNode
            let format = inputNode.outputFormat(forBus: 0)

            guard format.sampleRate > 0 && format.channelCount > 0 else {
                print("Invalid audio format")
                isRecording = false
                return
            }

            inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
                self?.request?.append(buffer)
            }

            audioEngine.prepare()
            try audioEngine.start()

            print("Microphone started - speak now!")

            recognitionTask = recognizer?.recognitionTask(with: request!) { [weak self] result, error in
                guard let self = self else { return }

                Task { @MainActor in
                    if let result = result {
                        self.transcript = result.bestTranscription.formattedString
                        print("Transcript: \(self.transcript)")
                    }

                    if let error = error {
                        let nsError = error as NSError

                        if nsError.domain == "kAFAssistantErrorDomain" && nsError.code == 1110 {
                            if !self.transcript.isEmpty {
                                print("Speech ended naturally")
                            } else {
                                print("No speech detected - try speaking louder or closer to mic")
                            }
                        } else if nsError.code == 1700 { // Recognition request was canceled
                            print("Recognition canceled by user")
                        } else {
                            print("Recognition error: \(error.localizedDescription)")
                        }
                    }
                }
            }

        } catch {
            print("Audio Engine error: \(error.localizedDescription)")
            await MainActor.run {
                isRecording = false
            }
        }
        #endif
    }

    func stopListening() {
        guard isRecording else { return }

        print("Stopping microphone...")

        isRecording = false

        if audioEngine.isRunning {
            audioEngine.stop()
        }

        if audioEngine.inputNode.numberOfInputs > 0 {
            audioEngine.inputNode.removeTap(onBus: 0)
        }

        request?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
        request = nil

        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to deactivate audio session: \(error.localizedDescription)")
        }

        print("Microphone stopped. Final transcript: '\(transcript)'")
    }

    private func requestPermissions() async -> Bool {
        return await withCheckedContinuation { continuation in
            if #available(iOS 17.0, *) {
                AVAudioApplication.requestRecordPermission { micGranted in
                    if !micGranted {
                        print("Microphone permission denied")
                        continuation.resume(returning: false)
                        return
                    }

                    SFSpeechRecognizer.requestAuthorization { authStatus in
                        let granted = authStatus == .authorized
                        if !granted {
                            print("Speech recognition permission denied: \(authStatus.rawValue)")
                        }
                        continuation.resume(returning: granted)
                    }
                }
            } else {
                AVAudioSession.sharedInstance().requestRecordPermission { micGranted in
                    if !micGranted {
                        print("Microphone permission denied")
                        continuation.resume(returning: false)
                        return
                    }

                    SFSpeechRecognizer.requestAuthorization { authStatus in
                        let granted = authStatus == .authorized
                        if !granted {
                            print("Speech recognition permission denied: \(authStatus.rawValue)")
                        }
                        continuation.resume(returning: granted)
                    }
                }
            }
        }
    }
}
