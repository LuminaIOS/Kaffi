//
//

import SwiftUI
import PhotosUI

struct RegisterFincaView: View {
    @Environment(\.dismiss) var dismiss

    @State private var vm = FincaViewModel(fincaService: FincaService(), supabase: client)
    @State private var selectedImage: PhotosPickerItem?

    @State private var showDropdown = false
    @State private var mostrarListaVariedades = false
    @State private var mostrarListaEspecies = false

    @State private var productorSeleccionadoId: Int? = nil
    @State private var showDropdownProductor = false
    @State private var productorVM = ProductorViewModel(productorService: ProductorService(), supabase: client)

    @StateObject private var mic = MicRecognizer()
    @State private var isListening = false
    @State private var speechParser = FincaSpeechParser()

    let variedadesDisponibles = ["Typica", "Bourbon", "Caturra"]
    let porte = ["Mixto", "Bajo", "Alto"]
    let tipos = ["Inga spp.", "Cedro rojo", "Plátano", "Chalum"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Foto del Finca")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        PhotosPicker(selection: $selectedImage, matching: .images) {
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
                        .onChange(of: selectedImage) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    await MainActor.run {
                                        vm.selectedImageData = data
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Productor*")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        Button {
                            withAnimation { showDropdownProductor.toggle() }
                        } label: {
                            HStack {
                                Text(
                                    productorSeleccionadoId.flatMap { selectedId in
                                        productorVM.productores.first { $0.id == selectedId }?.Nombre
                                    } ?? "Selecciona un productor"
                                )
                                .foregroundColor(productorSeleccionadoId == nil ? .gray : .black)
                                
                                Spacer()
                                Image(systemName: showDropdownProductor ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        
                        if showDropdownProductor {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(productorVM.productores) { productor in
                                    Button {
                                        productorSeleccionadoId = productor.idProductor
                                        withAnimation { showDropdownProductor = false }
                                    } label: {
                                        HStack {
                                            Text(productor.Nombre)
                                                .foregroundColor(.black)
                                            Spacer()
                                        }
                                        .padding()
                                    }
                                    
                                    if productor.id != productorVM.productores.last?.id {
                                        Divider()
                                    }
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .padding(.top, 4)
                        }
                    }
                    
                    
                        .task {
                            do {
                                try await productorVM.fetchProductores()
                            } catch {
                                print("Error cargando productores: \(error)")
                            }
                        }

                    
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nombre del Finca*")
                        TextField("Amanecer de la Sierra", text: $vm.finca)
                            .padding().background(Color(.systemGray6)).cornerRadius(8)
                    }
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hectareas*")
                            TextField("0", value: $vm.hectareas, format: .number)
                                .padding().background(Color(.systemGray6)).cornerRadius(8)
                                .keyboardType(.decimalPad)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Altitud (msnm)*")
                            TextField("1500", value: $vm.altitud, format: .number)
                                .padding().background(Color(.systemGray6)).cornerRadius(8)
                                .keyboardType(.decimalPad)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Variedad Cultivada*")
                            .font(.body)
                            .foregroundColor(.black)

                        Button {
                            withAnimation { mostrarListaVariedades.toggle() }
                        } label: {
                            HStack {
                                Text(vm.variedadesSeleccionadas.isEmpty
                                     ? "Selecciona variedades"
                                     : vm.variedadesSeleccionadas.joined(separator: ", "))
                                    .foregroundColor(vm.variedadesSeleccionadas.isEmpty ? .gray : .black)
                                Spacer()
                                Image(systemName: mostrarListaVariedades ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }

                        if mostrarListaVariedades {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(variedadesDisponibles, id: \.self) { variedad in
                                    Button {
                                        if vm.variedadesSeleccionadas.contains(variedad) {
                                            vm.variedadesSeleccionadas.removeAll { $0 == variedad }
                                        } else {
                                            vm.variedadesSeleccionadas.append(variedad)
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: vm.variedadesSeleccionadas.contains(variedad) ?
                                                  "checkmark.square.fill" : "square")
                                                .foregroundColor(.lightColor1)
                                            Text(variedad)
                                                .foregroundColor(.black)
                                            Spacer()
                                        }
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

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Porte de plantas*")
                            .font(.body)
                            .foregroundColor(.black)

                        Button {
                            withAnimation { showDropdown.toggle() }
                        } label: {
                            HStack {
                                Text(vm.portePlanta.isEmpty ? "Selecciona una opción" : vm.portePlanta)
                                    .foregroundColor(vm.portePlanta.isEmpty ? .gray : .black)
                                Spacer()
                                Image(systemName: showDropdown ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }

                        if showDropdown {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(porte, id: \.self) { variedad in
                                    Button {
                                        vm.portePlanta = variedad
                                        withAnimation { showDropdown = false }
                                    } label: {
                                        HStack {
                                            Text(variedad)
                                                .foregroundColor(.black)
                                            Spacer()
                                        }
                                        .padding()
                                    }
                                    if variedad != porte.last {
                                        Divider()
                                    }
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .padding(.top, -4)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Especie*")
                            .font(.body)
                            .foregroundColor(.black)

                        Button {
                            withAnimation { mostrarListaEspecies.toggle() }
                        } label: {
                            HStack {
                                Text(vm.especieSeleccionadas.isEmpty
                                     ? "Selecciona variedades"
                                     : vm.especieSeleccionadas.joined(separator: ", "))
                                    .foregroundColor(vm.especieSeleccionadas.isEmpty ? .gray : .black)
                                Spacer()
                                Image(systemName: mostrarListaEspecies ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }

                        if mostrarListaEspecies {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(tipos, id: \.self) { especie in
                                    Button {
                                        if vm.especieSeleccionadas.contains(especie) {
                                            vm.especieSeleccionadas.removeAll { $0 == especie }
                                        } else {
                                            vm.especieSeleccionadas.append(especie)
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: vm.especieSeleccionadas.contains(especie) ?
                                                  "checkmark.square.fill" : "square")
                                                .foregroundColor(.lightColor1)
                                            Text(especie)
                                                .foregroundColor(.black)
                                            Spacer()
                                        }
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
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Sombra Natural*")
                            TextField("%", value: $vm.sombra, format: .number)
                                .padding().background(Color(.systemGray6))
                                .cornerRadius(8)
                                .keyboardType(.decimalPad)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Árboles > 8 años*")
                            TextField("75", value: $vm.arboles, format: .number)
                                .padding().background(Color(.systemGray6))
                                .cornerRadius(8)
                                .keyboardType(.decimalPad)
                        }
                    }
                    
                    Button {
                        Task {
                            await vm.registrarFinca(productorId: productorSeleccionadoId)
                            selectedImage = nil
                            productorSeleccionadoId = nil
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

            if let finca = result["finca"], !finca.isEmpty {
                vm.finca = finca
            }

            if let hectareas = result["hectareas"], let val = Int(hectareas) {
                vm.hectareas = val
            }

            if let altitud = result["altitud"], let val = Int(altitud) {
                vm.altitud = val
            }

            if let variedades = result["variedades"], !variedades.isEmpty {
                vm.variedadesSeleccionadas = variedades.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            }

            if let especies = result["especies"], !especies.isEmpty {
                vm.especieSeleccionadas = especies.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            }

            if let sombra = result["sombra"], let val = Int(sombra) {
                vm.sombra = val
            }

            if let arboles = result["arboles"], let val = Int(arboles) {
                vm.arboles = val
            }

        } catch {
            print("AI Parsing failed:", error.localizedDescription)
        }
    }
}

#Preview {
    RegisterFincaView()
}
