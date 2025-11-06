
//
//  LoginViewModel.swift
//  Kaffi
//
//  Created by Bernardo Torres on 28/10/25.
//

import SwiftUI
import Supabase
import Observation

@MainActor
@Observable
final class AuthModel {

    var userEmail: String = ""
    var userPassword: String = ""
    var message: String = ""
    var messageType: MessageType = .info
    var isLoggedIn: Bool = false
    var isLoading: Bool = false
    
    enum MessageType {
        case success, error, info
    }
    
    func signUp(username: String, fechaNacimiento: Date) async {
        // Validaciones
        guard !userEmail.isEmpty else {
            message = "El correo electrónico es requerido"
            messageType = .error
            return
        }
        
        guard !userPassword.isEmpty else {
            message = "La contraseña es requerida"
            messageType = .error
            return
        }
        
        guard !username.isEmpty else {
            message = "El nombre de usuario es requerido"
            messageType = .error
            return
        }
        
        guard isValidEmail(userEmail) else {
            message = "El formato del correo electrónico no es válido"
            messageType = .error
            return
        }
        
        guard userPassword.count >= 6 else {
            message = "La contraseña debe tener al menos 6 caracteres"
            messageType = .error
            return
        }
        
        guard username.count >= 3 else {
            message = "El nombre de usuario debe tener al menos 3 caracteres"
            messageType = .error
            return
        }
        
        isLoading = true
        
        do {
            let response = try await auth.signUp(
                email: userEmail,
                password: userPassword
            )
            
            let userId = response.user.id
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let fechaISO = formatter.string(from: fechaNacimiento)
            
            try await client
                .from("usuario")
                .insert([
                    "id_usuario": AnyJSON(userId.uuidString),
                    "username": AnyJSON(username),
                    "birthdate": AnyJSON(fechaISO)
                ])
                .execute()
            
            message = "Registro exitoso. Revisa tu email para confirmar la cuenta."
            messageType = .success
            
            userEmail = ""
            userPassword = ""
            
        } catch let error as NSError {
            message = "Error en el registro: \(error.localizedDescription)"
            messageType = .error
            print("Error detallado: \(error)")
            print("User Info: \(error.userInfo)")
        } catch {
            message = "Error en el registro: \(error.localizedDescription)"
            messageType = .error
            print("Error: \(error)")
        }
        
        isLoading = false
    }
    
    func signIn() async {
        guard !userEmail.isEmpty else {
            message = "El correo electrónico es requerido"
            messageType = .error
            return
        }
        
        guard !userPassword.isEmpty else {
            message = "La contraseña es requerida"
            messageType = .error
            return
        }
        
        guard isValidEmail(userEmail) else {
            message = "El formato del correo electrónico no es válido"
            messageType = .error
            return
        }
        
        isLoading = true
        
        do {
            try await auth.signIn(email: userEmail, password: userPassword)
            message = "Sesión iniciada correctamente"
            messageType = .success
            isLoggedIn = true
            print("Usuario logueado: \(userEmail)")
        } catch {
            message = "Error al iniciar sesión: \(error.localizedDescription)"
            messageType = .error
            print("Error de login: \(error)")
        }
        
        isLoading = false
    }
    
    func signOut() async {
        isLoading = true
        
        do {
            try await auth.signOut()
            message = "Sesión cerrada correctamente"
            messageType = .success
            isLoggedIn = false
            userEmail = ""
            userPassword = ""
        } catch {
            message = "Error al cerrar sesión: \(error.localizedDescription)"
            messageType = .error
        }
        
        isLoading = false
    }
    
    // Función auxiliar para validar email
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
