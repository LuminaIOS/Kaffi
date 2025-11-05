//
//  LoginViewModel.swift
//  Kaffi
//
//  Created by Bernardo Torres on 28/10/25.
//

import SwiftUI
import Supabase
import Observation

@Observable
<<<<<<< HEAD
class AuthModel{
    var userEmail : String = ""
    var userPassword : String = ""
    var isLoading : Bool = false
    var authResult : Result<Void,Error>?{
        didSet{
            if case .failure = authResult{
                showAlert = true
            }
        }
    }
    var showAlert : Bool = false
    var errorMessage : String?
    
    private func toggleLoadingState(){
        withAnimation {
            isLoading.toggle()
        }
    }
    
    private func signIn() async throws{
        do{
            try await client.auth.signIn(
                email: userEmail,
                password: userPassword )
            authResult = .success(())
        }catch{
            authResult = .failure(error)
            errorMessage = error.localizedDescription
        }
            

=======
@MainActor
final class AuthModel {
    
    var userEmail: String = ""
    var userPassword: String = ""
    var message: String = ""
    var isLoggedIn: Bool = false
    var isLoading: Bool = false
    


    
    func signUp(username: String, fechaNacimiento: Date) async {
        guard !userEmail.isEmpty, !userPassword.isEmpty, !username.isEmpty else {
            message = "⚠️ Completa todos los campos"
            return
        }
>>>>>>> 8e80fae (login funcional)
        
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
                    "id": AnyJSON(userId.uuidString),
                    "username": AnyJSON(username),
                    "birthdate": AnyJSON(fechaISO)
                ])
                .execute()
            
            message = "✅ Registro exitoso. Revisa tu email para confirmar la cuenta."
            
            userEmail = ""
            userPassword = ""
            
        } catch let error as NSError {
            message = "❌ Error: \(error.localizedDescription)"
            print("📍 Error detallado: \(error)")
            print("📍 User Info: \(error.userInfo)")
        } catch {
            message = "❌ Error: \(error.localizedDescription)"
            print("📍 Error: \(error)")
        }
        
        isLoading = false
    }
    
    func signIn() async {
        guard !userEmail.isEmpty, !userPassword.isEmpty else {
            message = "⚠️ Ingresa email y contraseña"
            return
        }
        
        isLoading = true
        
        do {
            try await auth.signIn(email: userEmail, password: userPassword)
            message = "✅ Sesión iniciada correctamente"
            isLoggedIn = true
            print("Usuario logueado: \(userEmail)")
        } catch {
            message = "❌ Error: \(error.localizedDescription)"
            print("Error de login: \(error)")
        }
        
        isLoading = false
    }
    
    func signOut() async {
        isLoading = true
        
        do {
            try await auth.signOut()
            message = "✅ Sesión cerrada"
            isLoggedIn = false
            userEmail = ""
            userPassword = ""
        } catch {
            message = "❌ Error al cerrar sesión: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    
}
