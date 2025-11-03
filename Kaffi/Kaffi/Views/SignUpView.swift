//
//  SignUpView.swift
//  Kaffi
//
//  Created by Bernardo Torres on 29/10/25.
//

import SwiftUI

struct SignUpView: View {
@State private var email: String = ""
@State private var password: String = ""
@State private var nombreUsuario: String = ""
@State private var fechaDeNacimiento = Date()
@State private var genero: String = ""

var body: some View {
    ZStack {
        LinearGradient(colors: [Color.white, Color.lightColor1], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            
            Form {
                // Correo electronico
                Section("\(Image(systemName: "envelope")) Correo Electrónico") {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                
                // Contraseña
                Section("\(Image(systemName: "key")) Contraseña") {
                    SecureField("Password", text: $password)
                }
                
                // Nombre de usuario
                Section("\(Image(systemName: "person")) Nombre de Usuario") {
                    TextField("Nombre de Usuario", text: $nombreUsuario)
                }
                
                // Fecha de Nacimiento
                Section("\(Image(systemName: "calendar")) Fecha de nacimiento") {
                    DatePicker("Selecciona Fecha", selection: $fechaDeNacimiento, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .foregroundStyle(Color.secondary)
                }
                
                // Género
                Section("\(Image(systemName: "person.2")) Género") {
                    Picker("Selecciona tu género", selection: $genero) {
                        Text("Selecciona tu género").tag("")
                        Text("Masculino").tag("Masculino")
                        Text("Femenino").tag("Femenino")
                        Text("Otro").tag("Otro")
                        Text("Prefiero no decir").tag("Prefiero no decir")
                    }
                }
            }
            .frame(width: 370, height: 600)
            .scrollContentBackground(.hidden)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scrollDisabled(true)
            
            Button("Registrarme") {
                print("Registrarme tapped")
            }
            .frame(width: 200, height: 50)
            .background(Color.midColor2)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .foregroundStyle(Color.black)
            
            Spacer()
        }
        .padding()
    }
}

}

#Preview {
SignUpView()
}
