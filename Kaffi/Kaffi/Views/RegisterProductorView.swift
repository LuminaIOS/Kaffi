//
//
//

import SwiftUI
import PhotosUI
import AVFoundation

struct RegisterProductorView: View {
    @Environment(\.dismiss) var dismiss

    @State private var vm = ProductorViewModel(productorService: ProductorService(),supabase: client)

    @State private var selectedImage: PhotosPickerItem?

    @StateObject private var mic = MicRecognizer()
    @State private var isListening = false
    @State private var speechParser = ProductorSpeechParser()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Foto del Productor")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        PhotosPicker(
                            selection: $vm.selectedImage,
                            matching: .images
                        ) {
                            if let data = vm.selectedImageData,
                               let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 180)
                                    .clipped()
                                    .cornerRadius(10)
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray6))
                                        .frame(height: 180)
                                    
                                    VStack(spacing: 12) {
                                        Image(systemName: "arrow.up.square")
                                            .font(.system(size: 50))
                                            .foregroundColor(Color(.systemGray3))
                                        Text("Toca para subir una foto")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .onChange(of: vm.selectedImage) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    vm.selectedImageData = data
                                }
                            }
                        }
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Video")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        PhotosPicker(
                            selection: $vm.selectedVideo,
                            matching: .videos
                        ) {
                            ZStack {
                                if let data = vm.selectedVideoData, let image = thumbnailImage(for: data) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 180)
                                        .cornerRadius(12)
                                        .clipped()
                                } else {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemGray6))
                                        .frame(height: 180)
                                    
                                    VStack(spacing: 12) {
                                        Image(systemName: "video.badge.plus")
                                            .font(.system(size: 44))
                                            .foregroundColor(Color(.systemGray3))
                                        
                                        Text("Toca para subir un video")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .onChange(of: vm.selectedVideo) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    vm.selectedVideoData = data
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nombre*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Doña María de los Ángeles Gómez", text: $vm.nombre)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Edad*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("56", value: $vm.edad, format: .number)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .keyboardType(.numberPad)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Género*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Femenino", text: $vm.genero)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Generación Cafetalera*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("3ra generación de caficultores", text: $vm.generacion)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Ubicación*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Ejido El Zapotal, Motozintla, Chiapas, México", text: $vm.ubicacion)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Comunidad*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Plan de la Libertad (Baja), productora indígena", text: $vm.comunidad)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Latitud*")
                                .font(.body)
                                .foregroundColor(.black)
                            TextField("15.3631", value: $vm.latitud, format: .number)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .keyboardType(.decimalPad)
                        }
                        .frame(maxWidth: .infinity)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Longitud*")
                                .font(.body)
                                .foregroundColor(.black)
                            TextField("-92.2515", value: $vm.longitud, format: .number)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .keyboardType(.decimalPad)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Testimonio*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Aquí entre las montañas del sur, cultivamos café...", text: $vm.testimonio, axis: .vertical)
                            .lineLimit(4, reservesSpace: true)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .frame(height: 120)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

              
                    Button {
                        Task {
                            await vm.registrarProductor()
                            selectedImage = nil
                        }
                    } label: {
                        Text(vm.isLoading ? "Registrando..." : "Registrar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.midColor1)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(vm.isLoading)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 37)
                .padding(.top, 20)
            }
            .alert(vm.tituloAlerta, isPresented: $vm.mostrandoAlerta) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(vm.mensajeAlerta)
            }
        }
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .bottomTrailing) {
            micButton
                .padding(24)
        }
        .onDisappear {
            if isListening {
                mic.stop()
            }
        }
    }

    private var micButton: some View {
        Button {
            Task {
                if isListening {
                    mic.stop()
                    isListening = false
                    await processTranscript()
                } else {
                    await mic.startListening()
                    isListening = mic.isRecording
                }
            }
        } label: {
            ZStack {
                Circle()
                    .fill(isListening ? Color.red.opacity(0.9) : Color.blue.opacity(0.9))
                    .frame(width: 64, height: 64)

                Image(systemName: isListening ? "mic.fill" : "mic")
                    .font(.system(size: 26))
                    .foregroundColor(.white)
            }
            .shadow(radius: 6)
        }
        .scaleEffect(isListening ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isListening)
    }

    @MainActor
    func processTranscript() async {
        guard #available(iOS 18.1, *) else {
            print("iOS 18.1+ required for AI parsing")
            return
        }

        guard !mic.transcript.isEmpty else {
            print("No transcript to process")
            return
        }

        print("Processing transcript: '\(mic.transcript)'")

        do {
            let result = try await speechParser.parseSpeech(mic.transcript)
            print("Parsed result: \(result)")

            if let nombre = result["nombre"], !nombre.isEmpty {
                vm.nombre = nombre
            }

            if let edad = result["edad"], let val = Int(edad) {
                vm.edad = val
            }

            if let genero = result["genero"], !genero.isEmpty {
                vm.genero = genero
            }

            if let generacion = result["generacion"], !generacion.isEmpty {
                vm.generacion = generacion
            }

            if let ubicacion = result["ubicacion"], !ubicacion.isEmpty {
                vm.ubicacion = ubicacion
            }

            if let comunidad = result["comunidad"], !comunidad.isEmpty {
                vm.comunidad = comunidad
            }

            if let latitud = result["latitud"], let val = Double(latitud) {
                vm.latitud = val
            }

            if let longitud = result["longitud"], let val = Double(longitud) {
                vm.longitud = val
            }

            if let testimonio = result["testimonio"], !testimonio.isEmpty {
                vm.testimonio = testimonio
            }

        } catch {
            print("AI Parsing failed:", error.localizedDescription)
        }
    }
}

#Preview {
    RegisterProductorView()
}


func thumbnailImage(for data: Data) -> UIImage? {
    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mov")
    try? data.write(to: tempURL)
    
    let asset = AVAsset(url: tempURL)
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    imageGenerator.appliesPreferredTrackTransform = true
    
    if let cgImage = try? imageGenerator.copyCGImage(at: .zero, actualTime: nil) {
        return UIImage(cgImage: cgImage)
    }
    return nil
}
