//
//  RegisterFincaView.swift
//  Kaffi
//
//  Created by Angela Rodriguez on 05/11/25.
//

import SwiftUI
import PhotosUI

struct RegisterFincaView: View {
    @Environment(\.dismiss) var dismiss
    @State private var vm = FincaViewModel(fincaService: FincaService(), supabase: client)
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?

    @StateObject private var mic = MicRecognizer()
    @State private var isListening = false
    @State private var speechParser = FincaSpeechParser()

    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 16) {
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Foto de la finca")
                                .font(.body)
                                .foregroundColor(.black)
                            
                            PhotosPicker(selection: $selectedImage, matching: .images) {
                                if let imageData, let uiImage = UIImage(data: imageData) {
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
                            .onChange(of: selectedImage) { _, newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        imageData = data
                                        vm.selectedImage = UIImage(data: data)
                                    }
                                }
                            }
                        }

                        // Nombre de la finca
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Nombre de la finca*")
                                .font(.body)
                                .foregroundColor(.black)
                            TextField("Ej: Finca Santa Fe", text: $vm.finca)
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }

                        // Productor
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Productor*")
                                .font(.body)
                                .foregroundColor(.black)
                            TextField("Ej: Gilberto García", text: $vm.productor)
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }

                        // Estado y Ciudad
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Estado*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("Chiapas", text: $vm.estado)
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Ciudad*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("Motozintla", text: $vm.ciudad)
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                        }

                        // Latitud / Longitud
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Latitud")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("15.3654", value: $vm.latitud, format: .number)
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .keyboardType(.decimalPad)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Longitud")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("-92.2478", value: $vm.longitud, format: .number)
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .keyboardType(.decimalPad)
                            }
                        }

                        // Hectareas / Altitud
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Hectáreas*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("0", value: $vm.hectareas, format: .number)
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .keyboardType(.decimalPad)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Altitud (msnm)*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("1500", value: $vm.altitud, format: .number)
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .keyboardType(.decimalPad)
                            }
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tipo de Suelo")
                                .font(.body)
                                .foregroundColor(.black)
                            TextField("Suave", text: $vm.suelo)
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Descripción")
                                .font(.body)
                                .foregroundColor(.black)
                            TextField("Café de altura cultivado...", text: $vm.descripcion, axis: .vertical)
                                .lineLimit(4, reservesSpace: true)
                                .padding(12)
                                .frame(height: 120)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }

                        Button {
                            Task {
                                await vm.registrarFinca()
                                selectedImage = nil
                                imageData = nil
                            }
                        } label: {
                            Text(vm.isLoading ? "Registrando..." : "Registrar Finca")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(midColor1)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .disabled(vm.isLoading)

                    }
                    .padding(.horizontal, 37)
                    .padding(.top, 20)
                }
                .navigationTitle("Registrar Finca")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                        }
                    }
                }
                .alert(vm.tituloAlerta, isPresented: $vm.mostrandoAlerta) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(vm.mensajeAlerta)
                }
            }
            .navigationBarBackButtonHidden(true)
        }

        // 🔥 FLOATING MIC BUTTON
        .overlay(alignment: .bottomTrailing) {
            micButton
                .padding(24)
        }
        .onDisappear {
            // Clean up when view disappears
            if isListening {
                mic.stop()
            }
        }
    }


    // ----------------------------
    // MARK: - MIC BUTTON UI
    // ----------------------------
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

    // ----------------------------
    // MARK: - PROCESS TRANSCRIPT
    // ----------------------------
    @MainActor
    func processTranscript() async {
        guard #available(iOS 18.1, *) else {
            print("⚠️ iOS 18.1+ required for AI parsing")
            return
        }
        
        guard !mic.transcript.isEmpty else {
            print("⚠️ No transcript to process")
            return
        }

        print("🔄 Processing transcript: '\(mic.transcript)'")

        do {
            let result = try await speechParser.parseSpeech(mic.transcript)
            
            print("✅ Parsed result: \(result)")

            // Only update non-empty values
            if let finca = result["finca"], !finca.isEmpty {
                vm.finca = finca
            }
            if let productor = result["productor"], !productor.isEmpty {
                vm.productor = productor
            }
            if let estado = result["estado"], !estado.isEmpty {
                vm.estado = estado
            }
            if let ciudad = result["ciudad"], !ciudad.isEmpty {
                vm.ciudad = ciudad
            }
            if let latitud = result["latitud"], let val = Double(latitud) {
                vm.latitud = val
            }
            if let longitud = result["longitud"], let val = Double(longitud) {
                vm.longitud = val
            }
            if let hectareas = result["hectareas"], let val = Int(hectareas) {
                vm.hectareas = val
            }
            if let altitud = result["altitud"], let val = Double(altitud) {
                vm.altitud = val
            }
            if let suelo = result["suelo"], !suelo.isEmpty {
                vm.suelo = suelo
            }
            if let descripcion = result["descripcion"], !descripcion.isEmpty {
                vm.descripcion = descripcion
            }

        } catch {
            print("❌ AI Parsing failed:", error.localizedDescription)
        }
    }
}

#Preview {
    RegisterFincaView()
}
