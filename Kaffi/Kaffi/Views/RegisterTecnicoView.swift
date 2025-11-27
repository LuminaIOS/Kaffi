//
//  TecnicoView.swift
//  Trial
//
//  Created by Angela Rodriguez on 25/11/25.
//

import SwiftUI


struct RegisterTecnicoView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var tecnico: String = ""
    @State private var cargo: String = ""
    @State private var visita: String = ""
    @State private var resultado: String = ""
    @State private var fechaLevantamiento = Date()
    @State private var showingDatePicker = false
    @State private var fechaSeleccionada = false
    
    @State private var vm = TecnicoViewModel(tecnicoService: TecnicoService(),supabase: client)
    


    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Técnico Responsable de la Visita*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Eduardo Gómez", text: $vm.tecnico)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Cargo*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField(" Técnico de campo", text: $vm.cargo)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Tipo de Visita*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Inspección interna orgánica", text: $vm.visita)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Fecha de levantamiento de datos en app*")
                            .font(.body)
                            .foregroundColor(.black)

                        Button {
                            showingDatePicker.toggle()
                        } label: {
                            HStack {
                                Text(
                                    fechaSeleccionada
                                    ? vm.fechaLevantamiento.formatted(
                                        .dateTime
                                            .day(.twoDigits)
                                            .month(.abbreviated)
                                            .year()
                                    )
                                    : "Selecciona una fecha"
                                )
                                .foregroundColor(fechaSeleccionada ? .black : .gray)

                                Spacer()

                                Image(systemName: "calendar")
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }

                        if showingDatePicker {
                            DatePicker(
                                "",
                                selection: $vm.fechaLevantamiento,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .onChange(of: vm.fechaLevantamiento) { _ in
                                fechaSeleccionada = true
                            }
                        }
                    }


                    VStack(alignment: .leading, spacing: 4) {
                        Text("Resultado de Control Interno*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Cumple requisitos orgánicos...", text: $vm.resultado, axis: .vertical)
                            .lineLimit(4, reservesSpace: true)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .frame(height: 120)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
              
                    // Botón registrar
                    Button {
                        Task {
                            await vm.registrarTecnico()
                            fechaSeleccionada = false
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
    RegisterTecnicoView()
}
