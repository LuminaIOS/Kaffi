//
//  RegisterFincaView.swift
//  Kaffi
//
//  Created by Angela Rodriguez on 05/11/25.
//

import SwiftUI



struct RegisterFincaView: View {
    @Environment(\.dismiss) var dismiss
    @State var vm = FincaViewModel(fincaService: FincaService())
    
    var body: some View {
        NavigationStack {
            Form {
                VStack(spacing: 16) {
                    // Nombre de la finca
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nombre de la finca*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Ej: Finca Santa Fe", text: $vm.finca)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    // Productor
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Productor*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Ej: Gilberto García", text: $vm.productor)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
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
                                .padding(.vertical, 12)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Ciudad*")
                                .font(.body)
                                .foregroundColor(.black)
                            TextField("Motozintla", text: $vm.ciudad)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Latitud y Longitud
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Latitud")
                                .font(.body)
                                .foregroundColor(.black)
                            TextField("15.3654", value: $vm.latitud, format: .number)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .keyboardType(.decimalPad)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Longitud")
                                .font(.body)
                                .foregroundColor(.black)
                            TextField("-92.2478", value: $vm.longitud, format: .number)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .keyboardType(.decimalPad)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Hectareas y Altitud
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Hectáreas*")
                                .font(.body)
                                .foregroundColor(.black)
                            TextField("0", value: $vm.hectareas, format: .number)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .keyboardType(.decimalPad)
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Altitud (msnm)*")
                                .font(.body)
                                .foregroundColor(.black)
                            TextField("1500", value: $vm.altitud, format: .number)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .keyboardType(.decimalPad)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Tipo de suelo
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Tipo de Suelo")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Suave", text: $vm.suelo)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    // Descripcion
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Descripción")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Café de altura cultivado...", text: $vm.descripcion, axis: .vertical)
                            .lineLimit(4, reservesSpace: true)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .frame(height: 120)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    // registrar
                    Button {
                        Task { await vm.registrarFinca() }
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
                .padding()
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
}

#Preview {
    RegisterFincaView()
}
