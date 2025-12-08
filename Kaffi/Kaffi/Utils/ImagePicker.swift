//
//
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else {
                return
            }

            provider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error al cargar imagen: \(error.localizedDescription)")
                        return
                    }
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}

struct EditProfileView: View {
    @Environment(AuthModel.self) private var authModel
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isUploading = false
    
    @State private var nombreCompleto: String = ""
    @State private var username: String = ""
    @State private var birthdate: Date = Date()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    } else if let fotoURL = authModel.currentUser?.foto_url,
                              !fotoURL.isEmpty,
                              let url = URL(string: fotoURL) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 120, height: 120)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            case .failure:
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                    }
                    
                    Button(action: {
                        showImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Cambiar foto")
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(isUploading)
                    
                    if isUploading {
                        ProgressView("Subiendo imagen...")
                            .padding(.top, 10)
                    }
                }
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 15) {
                    VStack(alignment: .leading) {
                        Text("Nombre completo")
                            .font(.headline)
                        TextField("Nombre completo", text: $nombreCompleto)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Username")
                            .font(.headline)
                        TextField("Username", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Fecha de nacimiento")
                            .font(.headline)
                        DatePicker("", selection: $birthdate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    Task {
                        await saveProfile()
                    }
                }) {
                    Text("Guardar cambios")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(authModel.isLoading || isUploading)
                
                if !authModel.message.isEmpty {
                    Text(authModel.message)
                        .foregroundColor(authModel.messageType == .success ? .green : .red)
                        .padding()
                }
            }
        }
        .navigationTitle("Editar Perfil")
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .onChange(of: selectedImage) { oldValue, newValue in
            if let image = newValue {
                Task {
                    await uploadImage(image)
                }
            }
        }
        .onAppear {
            loadCurrentUserData()
        }
    }
    

    private func loadCurrentUserData() {
        if let user = authModel.currentUser {
            nombreCompleto = user.nombreCompleto
            username = user.username
            
            if let birthdateString = user.birthdate {
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                
                if let date = formatter.date(from: birthdateString) {
                    birthdate = date
                }
            }
        }
    }
    
    private func uploadImage(_ image: UIImage) async {
        isUploading = true
        
        do {
            let imageURL = try await authModel.uploadProfileImage(image)
            
            await authModel.updateUser(
                nombreCompleto: nombreCompleto,
                username: username,
                birthdate: birthdate,
                fotoURL: imageURL
            )
            
            selectedImage = nil
            
        } catch {
            print("Error al subir imagen: \(error)")
            authModel.message = "Error al subir la imagen: \(error.localizedDescription)"
            authModel.messageType = .error
        }
        
        isUploading = false
    }
    
    private func saveProfile() async {
        await authModel.updateUser(
            nombreCompleto: nombreCompleto,
            username: username,
            birthdate: birthdate,
            fotoURL: authModel.currentUser?.foto_url
        )
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
            .environment(AuthModel())
    }
}
