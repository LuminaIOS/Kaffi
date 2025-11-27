//
//  MicRecognizer.swift
//  Kaffi
//
//  Created by osc on 20/11/25.
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
    
    // MARK: - Start (Alias for startListening)
    func start() throws {
        Task {
            await startListening()
        }
    }
    
    // MARK: - Stop (Alias for stopListening)
    func stop() {
        stopListening()
    }
    
    // MARK: - Start Listening
    func startListening() async {
        #if targetEnvironment(simulator)
        print("⚠️ Mic disabled in Simulator")
        return
        #endif
        
        let granted = await requestPermissions()
        guard granted else {
            print("⚠️ Mic or Speech recognition permission denied")
            return
        }
        
        do {
            // Stop any existing session first
            stopListening()
            
            transcript = ""
            isRecording = true
            
            // Configure audio session with better settings
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            // Create request with better timeout settings
            request = SFSpeechAudioBufferRecognitionRequest()
            request?.shouldReportPartialResults = true
            request?.requiresOnDeviceRecognition = false  // Use cloud recognition for better accuracy
            
            // Add detection timeout (important!)
            if #available(iOS 13, *) {
                request?.taskHint = .dictation
            }
            
            let inputNode = audioEngine.inputNode
            let format = inputNode.outputFormat(forBus: 0)
            
            // Verify we have a valid format
            guard format.sampleRate > 0 && format.channelCount > 0 else {
                print("⚠️ Invalid audio format")
                isRecording = false
                return
            }
            
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
                self?.request?.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            print("🎤 Microphone started - speak now!")
            
            recognitionTask = recognizer?.recognitionTask(with: request!) { [weak self] result, error in
                guard let self = self else { return }
                
                Task { @MainActor in
                    if let result = result {
                        self.transcript = result.bestTranscription.formattedString
                        print("📝 Transcript: \(self.transcript)")
                    }
                    
                    // Handle errors
                    if let error = error {
                        let nsError = error as NSError
                        
                        // Ignore "No speech detected" if we already have a transcript
                        if nsError.domain == "kAFAssistantErrorDomain" && nsError.code == 1110 {
                            if !self.transcript.isEmpty {
                                print("✅ Speech ended naturally")
                            } else {
                                print("⚠️ No speech detected - try speaking louder or closer to mic")
                            }
                        } else if nsError.code == 1700 { // Recognition request was canceled
                            print("ℹ️ Recognition canceled by user")
                        } else {
                            print("❌ Recognition error: \(error.localizedDescription)")
                        }
                    }
                }
            }
            
        } catch {
            print("❌ Audio Engine error: \(error.localizedDescription)")
            await MainActor.run {
                isRecording = false
            }
        }
    }
    
    // MARK: - Stop Listening
    func stopListening() {
        guard isRecording else { return }
        
        print("🛑 Stopping microphone...")
        
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
        
        // Deactivate audio session
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("⚠️ Failed to deactivate audio session: \(error.localizedDescription)")
        }
        
        print("✅ Microphone stopped. Final transcript: '\(transcript)'")
    }
    
    // MARK: - Request Permissions
    private func requestPermissions() async -> Bool {
        return await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { micGranted in
                if !micGranted {
                    print("⚠️ Microphone permission denied")
                    continuation.resume(returning: false)
                    return
                }
                
                SFSpeechRecognizer.requestAuthorization { authStatus in
                    let granted = authStatus == .authorized
                    if !granted {
                        print("⚠️ Speech recognition permission denied: \(authStatus.rawValue)")
                    }
                    continuation.resume(returning: granted)
                }
            }
        }
    }
}
