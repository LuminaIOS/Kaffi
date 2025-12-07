//
//  RegisterProduccionView.swift
//  Kaffi
//

import SwiftUI

struct RegisterProduccionView: View {
    @State private var viewModel = ProduccionViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Seleccionar Finca*")
                        .font(.body)
                        .foregroundColor(.black)
                    
                    if viewModel.isLoading && viewModel.fincas.isEmpty {
                        HStack {
                            ProgressView()
                            Text("Cargando...")
                                .foregroundColor(.gray)
                        }
                        .padding()
                    } else {
                        Menu {
                            if viewModel.fincas.isEmpty {
                                Text("No tienes fincas registradas")
                                    .disabled(true)
                            } else {
                                ForEach(viewModel.fincas) { finca in
                                    Button(finca.nombre_finca ?? "Sin nombre") {
                                        viewModel.seleccionarFinca(finca)
                                    }
                                }
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
                    }
                }
                .padding(.top, 8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Manejo de suelos*")
                        .font(.body)
                        .foregroundColor(.black)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(viewModel.manejoSuelo, id: \.self) { p in
                            Text(p)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .foregroundColor(.black)
                        }
                    }
                    
                    HStack {
                        TextField("Agregar práctica...", text: $viewModel.nuevaPracticaSuelo)
                            .foregroundColor(.black)
                        
                        Button {
                            viewModel.agregarPracticaSuelo()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.midColor1)
                                .font(.system(size: 22))
                        }
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
                            Text(p)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .foregroundColor(.black)
                        }
                    }
                    
                    HStack {
                        TextField("Agregar práctica...", text: $viewModel.nuevaPracticaPlagas)
                            .foregroundColor(.black)
                        
                        Button {
                            viewModel.agregarPracticaPlagas()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.midColor1)
                                .font(.system(size: 22))
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Riego*")
                        .font(.body)
                        .foregroundColor(.black)
                    TextField("No usa riego", text: $viewModel.riego)
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
                            ForEach(viewModel.certificacionesDisponibles, id: \.self) { c in
                                Button {
                                    viewModel.seleccionarCertificacion(c)
                                } label: {
                                    HStack {
                                        Image(systemName: viewModel.certificacionesSeleccionadas.contains(c) ?
                                              "checkmark.square.fill" : "square")
                                            .foregroundColor(.lightColor1)
                                        ScrollView(.horizontal, showsIndicators: false){
                                            Text(c)
                                                .font(.system(size: 17))
                                                .lineLimit(1)
                                                .foregroundColor(.black)
                                        }
                                        Spacer()
                                    }
                                }

                               
                                if c == "Otro",
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
                        .zIndex(10)
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
                    } else {
                        Text("Registrar")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.midColor1)
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(viewModel.isLoading)
                
            }
            .padding(.horizontal, 37)
            .padding(.top, 20)
        }
        .navigationTitle("Registrar Producción")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.cargarFincas()
        }
        .alert(viewModel.tituloAlerta,
               isPresented: $viewModel.mostrandoAlerta) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.mensajeAlerta)
        }
    }
}

#Preview {
    NavigationView {
        RegisterProduccionView()
    }
}
