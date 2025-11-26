//
//  SignUpView.swift
//  Kaffi
//
//  Created by Bernardo Torres on 29/10/25.
//

import SwiftUI
	

struct SignUpView: View {
    @State private var nombreUsuario: String = ""
    @State private var fechaDeNacimiento = Date()
    @State private var nombreCompleto : String = ""
    @Bindable var vm: AuthModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.white, Color.lightColor1],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer(minLength: 50)
                
                VStack(spacing: 25) {
                    Form {
                        Section {
                            TextField("Nombre Completo", text: $nombreCompleto)
                                .textContentType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        } header: {
                            Label("Nombre completo", systemImage: "figure.stand")
                        }
                        
                        Section {	
                            TextField("Email", text: $vm.userEmail)
                                .textContentType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        } header: {
                            Label("Correo Electrónico", systemImage: "envelope")
                        }
                        
                        Section {
                            SecureField("Password", text: $vm.userPassword)
                        } header: {
                            Label("Contraseña", systemImage: "key")
                        } footer: {
                            Text("Mínimo 6 caracteres")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Section {
                            TextField("Nombre de Usuario", text: $nombreUsuario)
                        } header: {
                            Label("Nombre de Usuario", systemImage: "person")
                        } footer: {
                            Text("Mínimo 3 caracteres")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Section {
                            DatePicker(
                                "Selecciona Fecha",
                                selection: $fechaDeNacimiento,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                        } header: {
                            Label("Fecha de nacimiento", systemImage: "calendar")
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .frame(maxWidth: 350, maxHeight: 650)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                    
                    // Mensaje de estado
                    if !vm.message.isEmpty {
                        Text(vm.message)
                            .font(.caption)
                            .foregroundColor(messageColor)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(messageBackgroundColor)
                            )
                    }
                    
                    // Botón de registro
                    Button {
                        Task {
                            await vm.signUp(nombreCompleto: nombreCompleto, username: nombreUsuario, fechaNacimiento: fechaDeNacimiento)
                            if vm.messageType == .success {
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
                    .disabled(vm.isLoading || !isFormValid)
                }
                .padding()
                .frame(maxWidth: .infinity)
                
                Spacer(minLength: 50)
            }
        }
    }
    
    private var isFormValid: Bool {
        !vm.userEmail.isEmpty &&
        !vm.userPassword.isEmpty &&
        !nombreCompleto.isEmpty &&
        !nombreUsuario.isEmpty &&
        nombreUsuario.count >= 3 &&
        vm.userPassword.count >= 6
    }
    
    private var messageColor: Color {
        switch vm.messageType {
        case .success: return .green
        case .error: return .red
        case .info: return .blue
        }
    }
    
    private var messageBackgroundColor: Color {
        switch vm.messageType {
        case .success: return .green.opacity(0.1)
        case .error: return .red.opacity(0.1)
        case .info: return .blue.opacity(0.1)
        }
    }
}

#Preview {
    SignUpView(vm: AuthModel())
}
