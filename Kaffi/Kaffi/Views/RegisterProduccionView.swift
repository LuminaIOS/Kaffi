//
//

import SwiftUI
import Supabase

struct RegisterProduccionView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var vm = ProduccionViewModel(
        produccionService: ProduccionService(),
        fincaService: FincaService(),
        supabase: client
    )

    @StateObject private var mic = MicRecognizer()
    @State private var isListening = false
    @State private var speechParser = ProduccionSpeechParser()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Seleccionar Finca*")
                        .font(.body)
                        .foregroundColor(.black)
                    
                    if vm.isLoading && vm.fincas.isEmpty {
                        HStack {
                            ProgressView()
                            Text("Cargando...")
                                .foregroundColor(.gray)
                        }
                        .padding()
                    } else {
                        Menu {
                            if vm.fincas.isEmpty {
                                Text("No tienes fincas registradas")
                                    .disabled(true)
                            } else {
                                ForEach(vm.fincas) { finca in
                                    Button(finca.nombre_finca ?? "Sin nombre") {
                                        vm.seleccionarFinca(finca)
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text(vm.fincaSeleccionadaNombre)
                                    .foregroundColor(vm.fincaSeleccionadaNombre == "Seleccionar finca" ? .gray : .black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(.top, 8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Manejo de suelos*")
                        .font(.body)
                        .foregroundColor(.black)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(vm.manejoSuelo, id: \.self) { p in
                            Text(p)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .foregroundColor(.black)
                        }
                    }
                    
                    HStack {
                        TextField("Agregar práctica...", text: $vm.nuevaPracticaSuelo)
                            .foregroundColor(.black)
                        Button {
                            vm.agregarPracticaSuelo()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.midColor1)
                                .font(.system(size: 22))
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Control de plagas*")
                        .font(.body)
                        .foregroundColor(.black)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(vm.controlPlagas, id: \.self) { p in
                            Text(p)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .foregroundColor(.black)
                        }
                    }
                    
                    HStack {
                        TextField("Agregar práctica...", text: $vm.nuevaPracticaPlagas)
                            .foregroundColor(.black)
                        Button {
                            vm.agregarPracticaPlagas()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.midColor1)
                                .font(.system(size: 22))
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Riego*")
                        .font(.body)
                        .foregroundColor(.black)
                    TextField("No usa riego", text: $vm.riego)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .foregroundColor(.black)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Certificaciones*")
                        .font(.body)
                        .foregroundColor(.black)
                    
                    Button {
                        withAnimation { vm.mostrarListaCertificaciones.toggle() }
                    } label: {
                        HStack {
                            Text(
                                vm.certificacionesSeleccionadas.isEmpty
                                    ? "Selecciona certificaciones"
                                    : vm.certificacionesSeleccionadas.joined(separator: ", ")
                            )
                            .foregroundColor(vm.certificacionesSeleccionadas.isEmpty ? .gray : .black)
                            Spacer()
                            Image(systemName: vm.mostrarListaCertificaciones ? "chevron.up" : "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    if vm.mostrarListaCertificaciones {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(vm.certificacionesDisponibles, id: \.self) { c in
                                Button {
                                    vm.seleccionarCertificacion(c)
                                } label: {
                                    HStack {
                                        Image(systemName: vm.certificacionesSeleccionadas.contains(c) ?
                                              "checkmark.square.fill" : "square")
                                            .foregroundColor(.lightColor1)
                                        Text(c)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                }
                                
                                if c == "Otro", vm.certificacionesSeleccionadas.contains("Otro") {
                                    TextField("Especifica certificación...", text: $vm.otraCertificacion)
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(8)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                        .transition(.opacity)
                        .zIndex(10)
                    }
                }
                
                Button {
                    Task { await vm.registrarProduccion() }
                } label: {
                    if vm.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Registrar")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.midColor1)
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(vm.isLoading)
            }
            .padding(.horizontal, 37)
            .padding(.top, 20)
        }
        .navigationTitle("Registrar Producción")
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.cargarFincas() }
        .alert(vm.tituloAlerta,
               isPresented: $vm.mostrandoAlerta) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(vm.mensajeAlerta)
        }
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

            if let manejoSuelo = result["manejoSuelo"], !manejoSuelo.isEmpty {
                let practicas = manejoSuelo.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                vm.manejoSuelo = practicas
            }

            if let controlPlagas = result["controlPlagas"], !controlPlagas.isEmpty {
                let practicas = controlPlagas.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                vm.controlPlagas = practicas
            }

            if let riego = result["riego"], !riego.isEmpty {
                vm.riego = riego
            }

            if let certificaciones = result["certificaciones"], !certificaciones.isEmpty {
                let certs = certificaciones.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                vm.certificacionesSeleccionadas = certs
            }

        } catch {
            print("AI Parsing failed:", error.localizedDescription)
        }
    }
}

#Preview {
    NavigationView {
        RegisterProduccionView()
    }
}
