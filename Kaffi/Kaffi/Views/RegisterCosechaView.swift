//
//  CosechaView.swift
//  Trial
//
//  Created by Angela Rodriguez on 26/11/25.
//

import SwiftUI
import PhotosUI

struct RegisterCosechaView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?

    @State private var expanded = true
    @State private var expanded2 = false
    @State private var expanded3 = false
    
    @State private var vm = CosechaViewModel(cosechaService: CosechaService(), supabase: client)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    
                    DisclosureGroup("Datos de Cosecha", isExpanded: $expanded) {

                        VStack(spacing: 16) {

                            // foto
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Foto del Rancho")
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

                            // Volumen
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Volumen Producido*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("27 quintales pergamino", text: $vm.volumen)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            
                            // Fecha
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Fecha de Cosecha*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("Noviembre 2024", text: $vm.inicioCosecha)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Fecha de Fin Cosecha*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("Febrero 2025", text: $vm.finCosecha)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            
                            // Método
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Método de procesamiento*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("Lavado ecológico", text: $vm.procesamiento)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }

                            // Fermentación
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Fermentación (hrs)*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("18", value: $vm.fermentacion, format: .number)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .keyboardType(.numberPad)
                            }

                            // Secado
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Secado*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("Camas africanas al sol durante 12 días", text: $vm.secado)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }

                            // Subproductos
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Subproductos*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("Pulpa compostada y usada como fertilizante", text: $vm.subproductos)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }

                            // Agua
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Tratamiento de agua*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("Filtro anaeróbico con lombricomposta", text: $vm.tratamientoAgua)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.top, 12)

                    }
                    
                    DisclosureGroup("Indicadores Ambientales", isExpanded: $expanded2) {
                        VStack(spacing: 16) {
                            
                            Text("Huella de Carbono")
                                .font(.body)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 20)
                            
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Emisiones estimadas (kg CO₂e/kg)*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("0.94", value: $vm.emisiones, format: .number)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .keyboardType(.decimalPad)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Captura por árboles sombra (kg CO₂e/kg)*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("-1.08", value: $vm.capturaArboles, format: .number)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .keyboardType(.decimalPad)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Resultado neto (kg CO₂e/kg)*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("-0.14", value: $vm.emisionesNetas, format: .number)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .keyboardType(.decimalPad)
                            }
                            
                            // Huella Hídrica
                            Text("Huella Hídrica")
                                .font(.body)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 20)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Agua en beneficio (L/kg)*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("1.2", value: $vm.aguaBeneficio, format: .number)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .keyboardType(.decimalPad)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Agua de riego (L/kg)*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("0", value: $vm.aguaRiego, format: .number)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .keyboardType(.decimalPad)
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Huella total estimada (L/kg)*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("1.2 L/kg café verde", text: $vm.huellaTotal)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .keyboardType(.decimalPad)
                            }
                            
                        }
                    }
                    
                    DisclosureGroup("Calidad y Producto Fina", isExpanded: $expanded3) {
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Puntaje de catación (Q Grader)*")
                                TextField("82.25", value: $vm.catacion, format: .number)
                                    .padding().background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .keyboardType(.decimalPad)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Perfil sensorial*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("Aromas a panela y jazmín...", text: $vm.sensorial, axis: .vertical)
                                    .lineLimit(4, reservesSpace: true)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .frame(height: 120)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Empaque*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("Bolsa compostable 250g...", text: $vm.empaque, axis: .vertical)
                                    .lineLimit(4, reservesSpace: true)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .frame(height: 120)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Contenido nutricional (por 250 gr)*")
                                    .font(.body)
                                    .foregroundColor(.black)
                                TextField("Calorías, Azúcares, Cafeína...", text: $vm.nutricional, axis: .vertical)
                                    .lineLimit(4, reservesSpace: true)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 12)
                                    .frame(height: 120)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            
                        }
                    }
                    
                    Button {
                        Task {
                            await vm.registrarCosecha()
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
    }
}

#Preview {
    RegisterCosechaView()
}

