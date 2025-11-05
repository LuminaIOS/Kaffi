//
//  SignUpView.swift
//  Kaffi
//
//  Created by Bernardo Torres on 29/10/25.
//

import SwiftUI

import SwiftUI

struct SignUpView: View {
    @State private var nombreUsuario: String = ""
    @State private var fechaDeNacimiento = Date()
    @Bindable var vm: AuthModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Fondo degradado
            LinearGradient(
                colors: [Color.white, Color.lightColor1],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Contenido centrado verticalmente
            VStack {
                Spacer(minLength: 50)
                
                VStack(spacing: 25) {
                    // 🧾 Formulario
                    Form {
                        Section("\(Image(systemName: "envelope")) Correo Electrónico") {
                            TextField("Email", text: $vm.userEmail)
                                .textContentType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }
                        
                        Section("\(Image(systemName: "key")) Contraseña") {
                            SecureField("Password", text: $vm.userPassword)
                        }
                        
                        Section("\(Image(systemName: "person")) Nombre de Usuario") {
                            TextField("Nombre de Usuario", text: $nombreUsuario)
                        }
                        
                        Section("\(Image(systemName: "calendar")) Fecha de nacimiento") {
                            DatePicker(
                                "Selecciona Fecha",
                                selection: $fechaDeNacimiento,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .frame(maxWidth: 350, maxHeight: 440)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                    
                    // Mensaje de estado
                    if !vm.message.isEmpty {
                        Text(vm.message)
                            .font(.caption)
                            .foregroundColor(vm.message.contains("❌") ? .red : .green)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    // Botón de registro
                    Button {
                        Task {
                            await vm.signUp(username: nombreUsuario, fechaNacimiento: fechaDeNacimiento)
                            if vm.message.contains("✅") {
                                dismiss()
                            }
                        }
                    } label: {
                        if vm.isLoading {
                            ProgressView()
                                .frame(width: 200, height: 50)
                        } else {
                            Text("Registrarme")
                                .frame(width: 200, height: 50)
                        }
                    }
                    .background(Color.midColor2)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(.black)
                    .disabled(vm.isLoading || nombreUsuario.isEmpty)
                }
                .padding()
                .frame(maxWidth: .infinity)
                
                Spacer(minLength: 50)
            }
        }
    }
}

#Preview {
    SignUpView(vm: AuthModel())
}
