//
//  ProduccionView.swift
//

import SwiftUI

struct RegisterProduccionView: View {
    @State private var viewModel = ProduccionViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Seleccionar Finca*")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        Menu {
                            ForEach(viewModel.fincas) { finca in
                                Button(finca.nombre_finca) {
                                    viewModel.seleccionarFinca(finca)
                                }
                            }
                            
                            if viewModel.fincas.isEmpty {
                                Text("No hay fincas disponibles")
                                    .disabled(true)
                            }
                        } label: {
                            HStack {
                                Text(viewModel.fincaSeleccionadaNombre)
                                    .foregroundColor(viewModel.fincaSeleccionadaNombre == "Seleccionar finca" ? .gray : .black)
                                
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        
                        if viewModel.fincas.isEmpty && !viewModel.isLoading {
                            Button("Cargar fincas") {
                                Task {
                                    await viewModel.cargarFincas()
                                }
                            }
                            .padding(.top, 8)
                            .foregroundColor(.midColor1)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Manejo de suelos*")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(viewModel.manejoSuelo, id: \.self) { p in
                                HStack {
                                    Text(p)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Button {
                                        if let index = viewModel.manejoSuelo.firstIndex(of: p) {
                                            viewModel.manejoSuelo.remove(at: index)
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .font(.caption)
                                    }
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        }
                        
                        HStack {
                            TextField("Agregar práctica...", text: $viewModel.nuevaPracticaSuelo)
                                .foregroundColor(.black)
                                .onSubmit {
                                    viewModel.agregarPracticaSuelo()
                                }
                            
                            Button {
                                viewModel.agregarPracticaSuelo()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.midColor1)
                                    .font(.system(size: 22))
                            }
                            .disabled(viewModel.nuevaPracticaSuelo.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Control de plagas*")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(viewModel.controlPlagas, id: \.self) { p in
                                HStack {
                                    Text(p)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Button {
                                        if let index = viewModel.controlPlagas.firstIndex(of: p) {
                                            viewModel.controlPlagas.remove(at: index)
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .font(.caption)
                                    }
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        }
                        
                        HStack {
                            TextField("Agregar práctica...", text: $viewModel.nuevaPracticaPlagas)
                                .foregroundColor(.black)
                                .onSubmit {
                                    viewModel.agregarPracticaPlagas()
                                }
                            
                            Button {
                                viewModel.agregarPracticaPlagas()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.midColor1)
                                    .font(.system(size: 22))
                            }
                            .disabled(viewModel.nuevaPracticaPlagas.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    
                    // Riego
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Riego*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Ej: Riego por goteo, No usa riego...", text: $viewModel.riego)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .foregroundColor(.black)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Certificaciones*")
                            .font(.body)
                            .foregroundColor(.black)

                        Button {
                            withAnimation {
                                viewModel.mostrarListaCertificaciones.toggle()
                            }
                        } label: {
                            HStack {
                                Text(
                                    viewModel.certificacionesSeleccionadas.isEmpty
                                    ? "Selecciona certificaciones"
                                    : viewModel.certificacionesSeleccionadas.joined(separator: ", ")
                                )
                                .lineLimit(1)
                                .foregroundColor(viewModel.certificacionesSeleccionadas.isEmpty ? .gray : .black)
                                
                                Spacer()
                                Image(systemName: viewModel.mostrarListaCertificaciones ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }

                        if viewModel.mostrarListaCertificaciones {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(viewModel.certificacionesDisponibles, id: \.self) { certificacion in
                                    Button {
                                        viewModel.seleccionarCertificacion(certificacion)
                                    } label: {
                                        HStack {
                                            Image(systemName: viewModel.certificacionesSeleccionadas.contains(certificacion) ?
                                                  "checkmark.square.fill" : "square")
                                                .foregroundColor(.lightColor1)
                                            Text(certificacion)
                                                .font(.system(size: 17))
                                                .lineLimit(2)
                                                .foregroundColor(.black)
                                            Spacer()
                                        }
                                    }
                                    
                                    // Campo para "Otro"
                                    if certificacion == "Otro",
                                       viewModel.certificacionesSeleccionadas.contains("Otro") {
                                        TextField("Especifica certificación...", text: $viewModel.otraCertificacion)
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
                        }
                    }
                    .padding(.vertical)
                    
                    Button {
                        Task {
                            await viewModel.registrarProduccion()
                        }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Registrar")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(Color.midColor1)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .disabled(viewModel.isLoading)
                }
                .padding(.horizontal, 37)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .navigationTitle("Registrar Producción")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
        .task {
            await viewModel.cargarFincas()
        }
        .alert(viewModel.tituloAlerta,
               isPresented: $viewModel.mostrandoAlerta) {
            Button("OK", role: .cancel) {
                if viewModel.tituloAlerta == "Éxito" {
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.mensajeAlerta)
        }
    }
}

#Preview {
    RegisterProduccionView()
}
