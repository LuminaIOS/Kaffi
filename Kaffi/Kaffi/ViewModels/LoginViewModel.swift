
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
    var currentId : String = ""
    var currentUser : Usuario? = nil
    var messageType: MessageType = .info
    var isLoggedIn: Bool = false
    var isLoading: Bool = false
    
    enum MessageType {
        case success, error, info
    }
    
    func fetchUserData() async {
        guard !currentId.isEmpty else {
            print("No hay usuario logueado")
            return
        }
        
        isLoading = true
        
        do {
            let response: [Usuario] = try await client
                .from("usuario")
                .select()
                .eq("id_usuario", value: currentId)
                .execute()
                .value
            
            if let user = response.first {
                currentUser = user
                
                print("Username: \(user.username)")
                print("Nombre: \(user.nombreCompleto)")
                print("ID: \(user.id)")
            } else {
                print("No se encontró usuario con id: \(currentId)")
                message = "No se encontraron datos del usuario"
                messageType = .error
            }
        } catch let error as NSError {
            print("Error al obtener datos del usuario:")
            print("Descripción: \(error.localizedDescription)")
            print("Código: \(error.code)")
            print("UserInfo: \(error.userInfo)")
            message = "Error al cargar datos del usuario"
            messageType = .error
        } catch {
            print("error desconocido: \(error)")
            message = "Error al cargar datos del usuario"
            messageType = .error
        }
        
        isLoading = false
    }
    
    func signUp(nombreCompleto : String, username: String, fechaNacimiento: Date) async {
        // Validaciones
        guard !userEmail.isEmpty else {
            message = "El correo electrónico es requerido"
            messageType = .error
            return
        }
        
        guard !nombreCompleto.isEmpty else{
            message = "El nombre completo es requerido"
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
                    "birthdate": AnyJSON(fechaISO),
                    "nombreCompleto": AnyJSON(nombreCompleto)
                ])
                .execute()
            
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
            let session = try await auth.signIn(email: userEmail, password: userPassword)
            currentId = session.user.id.uuidString
            
            await fetchUserData()
            
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
            currentUser = nil
            currentId = ""
            userEmail = ""
            userPassword = ""
        } catch {
            message = "Error al cerrar sesión: \(error.localizedDescription)"
            messageType = .error
        }
        
        isLoading = false
    }
    
//    func checkSession() async {
//        do {
//            if let session = try await auth.session {
//                currentId = session.user.id.uuidString
//                await fetchUserData()
//                isLoggedIn = true	
//                print("Sesión restaurada para: \(currentId)")
//            }
//        } catch {
//            print("No hay sesión activa: \(error)")
//        }
//    }
    
    // Función auxiliar para validar email
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
