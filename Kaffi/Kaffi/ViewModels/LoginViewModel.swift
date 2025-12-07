
//
//  LoginViewModel.swift
//  Kaffi
//
//  Created by Bernardo Torres on 28/10/25.
//
import SwiftUI
import Supabase
import Observation
import UIKit

@MainActor
@Observable
final class AuthModel {

    var userEmail: String = ""
    var userPassword: String = ""
    var message: String = ""
    var currentId: String = ""
    var currentUser: Usuario? = nil
    var messageType: MessageType = .info
    var isLoggedIn: Bool = false
    var isLoading: Bool = false
    var tempProfileImage: UIImage? = nil

    enum MessageType {
        case success, error, info
    }

    func fetchUserData() async {
        guard !currentId.isEmpty else {
            print("No hay usuario")
            return
        }

        isLoading = true
        let normalizedId = currentId.lowercased()

        do {
            let rawResponse = try await client
                .from("usuario")
                .select()
                .eq("id_usuario", value: normalizedId)
                .execute()

            let response: [Usuario] = try JSONDecoder().decode([Usuario].self, from: rawResponse.data)

            if let user = response.first {
                currentUser = user
            } else {
                message = "No se encontraron datos del usuario"
                messageType = .error
            }

        } catch {
            message = "Error al cargar datos del usuario"
            messageType = .error
        }

        isLoading = false
    }

    func signUp(nombreCompleto: String,
                username: String,
                fechaNacimiento: Date,
                cooperativa: String,
                rol: String) async {

        guard !userEmail.isEmpty else { message = "El correo es requerido"; messageType = .error; return }
        guard !userPassword.isEmpty else { message = "La contraseña es requerida"; messageType = .error; return }
        guard !nombreCompleto.isEmpty else { message = "El nombre es requerido"; messageType = .error; return }
        guard !username.isEmpty else { message = "El nombre de usuario es requerido"; messageType = .error; return }

        isLoading = true

        do {
            let response = try await auth.signUp(email: userEmail, password: userPassword)
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
                    "nombreCompleto": AnyJSON(nombreCompleto),
                    "Cooperativa": AnyJSON(cooperativa),
                    "rol": AnyJSON(rol)
                ])
                .execute()

        
            let debugCheck = try await client
                .from("usuario")
                .select()
                .eq("id_usuario", value: userId.uuidString)
                .execute()

            if let json = String(data: debugCheck.data, encoding: .utf8) {
            
            }

            messageType = .success

        } catch {
            message = "Error en el registro: \(error.localizedDescription)"
            messageType = .error
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
            currentId = session.user.id.uuidString.lowercased()

            await fetchUserData()
 
            if currentUser != nil {
                message = "Sesión iniciada correctamente"
                messageType = .success
                isLoggedIn = true
            } else {
                print("Usuario autenticado pero no encontrado en tabla `usuario`, intentando crear...")

                let defaultUsername = userEmail.components(separatedBy: "@").first ?? "usuario"
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                let fechaNacimiento = formatter.string(from: Date())

                do {
                    try await client
                        .from("usuario")
                        .insert([
                            "id_usuario": AnyJSON(currentId),
                            "username": AnyJSON(defaultUsername),
                            "nombreCompleto": AnyJSON("Sin nombre"),
                            "birthdate": AnyJSON(fechaNacimiento),
                            "Cooperativa": AnyJSON("Sin cooperativa"),
                            "rol": AnyJSON("usuario")
                        ])
                        .execute()

                    await fetchUserData()
                } catch {
                    print("Fallo al crear usuario tras login: \(error)")
                }

                message = "Sesión iniciada"
                messageType = .success
                isLoggedIn = true
            }

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

    func updateUser(
        nombreCompleto: String,
        username: String,
        birthdate: Date,
        fotoURL: String?
    ) async {
        guard !currentId.isEmpty else { return }

        isLoading = true

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let birthdateISO = formatter.string(from: birthdate)

        var updateData: [String: AnyJSON] = [
            "nombreCompleto": AnyJSON(stringLiteral: nombreCompleto),
            "username": AnyJSON(stringLiteral: username),
            "birthdate": AnyJSON(stringLiteral: birthdateISO)
        ]

        if let fotoURL = fotoURL {
            updateData["foto_url"] = AnyJSON(stringLiteral: fotoURL)
        }

        do {
            try await client
                .from("usuario")
                .update(updateData)
                .eq("id_usuario", value: currentId)
                .execute()

            await fetchUserData()
            message = "Datos actualizados correctamente"
            messageType = .success
        } catch {
            message = "Error al actualizar el perfil: \(error.localizedDescription)"
            messageType = .error
        }

        isLoading = false
    }

    func uploadProfileImage(_ image: UIImage) async throws -> String {
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(domain: "image-conversion", code: 0)
        }

        let filePath = "\(currentId)/profile.jpg"

        _ = try await client.storage
            .from("profile-pics")
            .upload(filePath, data: data, options: .init(contentType: "image/jpeg", upsert: true))

        let publicURL = try client.storage
            .from("profile-pics")
            .getPublicURL(path: filePath)

        return publicURL.absoluteString
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
