//
//  ProfileView.swift
//  Kaffi
//
//  Created by Bernardo Torres on 21/11/25.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AuthModel.self) var auth

    @State private var isEditing = false
    @State private var tempNombre = ""
    @State private var tempUsername = ""
    @State private var tempBirthdate = Date()
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.lightColor1.opacity(0.15)
                    .ignoresSafeArea()

                if auth.isLoading {
                    VStack {
                        ProgressView("Cargando perfil...")
                        Text("ID: \(auth.currentId)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else {
                    VStack(spacing: 20) {
                        Spacer().frame(height: 20)

                        VStack(spacing: 8) {
                            Button {
                                if isEditing {
                                    showImagePicker = true
                                }
                            } label: {
                                ZStack {
                                    if let selectedImage = selectedImage {
                                        Image(uiImage: selectedImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 120, height: 120)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.darkColor1, lineWidth: 3))
                                    } else if let urlString = auth.currentUser?.foto_url,
                                              !urlString.isEmpty,
                                              let url = URL(string: urlString) {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                            case .failure:
                                                Image(systemName: "person.crop.circle.fill")
                                                    .resizable()
                                                    .foregroundColor(Color.darkColor1.opacity(0.7))
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.darkColor1, lineWidth: 3))
                                    } else {
                                        Image(systemName: "person.crop.circle.fill")
                                            .resizable()
                                            .frame(width: 120, height: 120)
                                            .foregroundColor(Color.darkColor1.opacity(0.7))
                                    }

                                    if isEditing {
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Spacer()
                                                Image(systemName: "camera.fill")
                                                    .foregroundColor(.white)
                                                    .padding(8)
                                                    .background(Color.darkColor1)
                                                    .clipShape(Circle())
                                                    .offset(x: -10, y: -10)
                                            }
                                        }
                                        .frame(width: 120, height: 120)
                                    }
                                }
                            }
                            .disabled(!isEditing)

                            Text(auth.currentUser?.nombreCompleto ?? "Usuario")
                                .font(.title2)
                                .bold()

                            Text("@\(auth.currentUser?.username ?? "sin_username")")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }
                        .padding(.bottom, 10)

                        Form {
                            Section("Información Personal") {
                                if isEditing {
                                    TextField("Nombre completo", text: $tempNombre)
                                    TextField("Usuario", text: $tempUsername)
                                    DatePicker("Fecha de nacimiento",
                                               selection: $tempBirthdate,
                                               displayedComponents: .date)
                                } else {
                                    infoRow("Nombre", auth.currentUser?.nombreCompleto)
                                    infoRow("Usuario", auth.currentUser?.username)
                                    infoRow("Nacimiento", formattedDate(auth.currentUser?.birthdate ?? ""))

                                    if let coop = auth.currentUser?.cooperativa {
                                        infoRow("Cooperativa", coop)
                                    }

                                    if let rol = auth.currentUser?.rol {
                                        infoRow("Rol", rol)
                                    }
                                }
                            }

                
                            Section {
                                if isEditing {
                                    Button("Guardar Cambios") {
                                        Task { await guardarCambios() }
                                    }
                                    .disabled(tempNombre.isEmpty || tempUsername.isEmpty)

                                    Button("Cancelar", role: .cancel) {
                                        cancelarEdicion()
                                    }
                                } else {
                                    Button("Editar Perfil") {
                                        loadTempData()
                                        withAnimation { isEditing = true }
                                    }
                                }
                            }

                            Section("Cuenta") {
                                Button("Cerrar sesión", role: .destructive) {
                                    Task { await auth.signOut() }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Perfil")
            .task {
                if !auth.currentId.isEmpty {
                    await auth.fetchUserData()
                    loadTempData()
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
    }

    @ViewBuilder
    private func infoRow(_ title: String, _ value: String?, color: Color = .secondary) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value ?? "-")
                .foregroundColor(color)
        }
    }

    private func guardarCambios() async {
        var nuevaFotoURL: String? = nil

        if let img = selectedImage {
            do {
                nuevaFotoURL = try await auth.uploadProfileImage(img)
            
            } catch {
                print("Error subiendo foto: \(error)")
            }
        }

        await auth.updateUser(
            nombreCompleto: tempNombre,
            username: tempUsername,
            birthdate: tempBirthdate,
            fotoURL: nuevaFotoURL
        )

        await auth.fetchUserData()
        selectedImage = nil
        withAnimation { isEditing = false }
    }


    private func cancelarEdicion() {
        loadTempData()
        selectedImage = nil
        withAnimation { isEditing = false }
    }


    private func loadTempData() {
        guard let u = auth.currentUser else {
            print("loadTempData: currentUser es nil")
            return
        }

//        tempNombre = u.nombreCompleto ?? "Sin nombre"
//        tempUsername = u.username ?? "usuario"

        let isoFormatter = ISO8601DateFormatter()

        let simpleFormatter = DateFormatter()
        simpleFormatter.dateFormat = "yyyy-MM-dd"

        if let birthStr = u.birthdate {
            if let d = isoFormatter.date(from: birthStr) {
                tempBirthdate = d
            } else if let d = simpleFormatter.date(from: birthStr) {
                tempBirthdate = d
            } else {
                print("⚠️ No se pudo parsear la fecha con ningún formato: \(birthStr)")
            }
        }
    }

    // MARK: - Formatear fecha para mostrar
    private func formattedDate(_ iso: String) -> String {
        guard !iso.isEmpty else { return "-" }

        let isoFormatter = ISO8601DateFormatter()

        let simpleFormatter = DateFormatter()
        simpleFormatter.dateFormat = "yyyy-MM-dd"

        let output = DateFormatter()
        output.dateStyle = .medium
        output.locale = Locale(identifier: "es_MX")

        if let d = isoFormatter.date(from: iso) {
            return output.string(from: d)
        } else if let d = simpleFormatter.date(from: iso) {
            return output.string(from: d)
        }

        return "-"
    }
}

#Preview {
    ProfileView().environment(AuthModel())
}

