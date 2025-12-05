//
//  ProductorView.swift
//  Trial
//
//  Created by Angela Rodriguez on 24/11/25.
//

import SwiftUI
import PhotosUI

struct RegisterProductorView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var vm = ProductorViewModel(productorService: ProductorService(),supabase: client)

    @State private var selectedImage: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    
                    // FOTO
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Foto del Productor")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        PhotosPicker(
                            selection: $vm.selectedImage,
                            matching: .images
                        ) {
                            if let data = vm.selectedImageData,
                               let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 180)
                                    .clipped()
                                    .cornerRadius(10)
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray6))
                                        .frame(height: 180)
                                    
                                    VStack(spacing: 12) {
                                        Image(systemName: "arrow.up.square")
                                            .font(.system(size: 50))
                                            .foregroundColor(Color(.systemGray3))
                                        Text("Toca para subir una foto")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .onChange(of: vm.selectedImage) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    vm.selectedImageData = data
                                }
                            }
                        }
                    }
                    
                    
                    // VIDEO
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Video")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        PhotosPicker(
                            selection: $vm.selectedVideo,
                            matching: .videos
                        ) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                                    .frame(height: 180)
                                
                                VStack(spacing: 12) {
                                    Image(systemName: "video.badge.plus")
                                        .font(.system(size: 44))
                                        .foregroundColor(Color(.systemGray3))
                                    
                                    Text("Toca para subir un video")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .onChange(of: vm.selectedVideo) { _, newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    vm.selectedVideoData = data
                                }
                            }
                        }
                    }

                    // Nombre
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nombre*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Doña María de los Ángeles Gómez", text: $vm.nombre)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    // Edad
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Edad*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("56", value: $vm.edad, format: .number)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .keyboardType(.numberPad)
                    }

                    // Género
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Género*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Femenino", text: $vm.genero)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    // Generación
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Generación Cafetalera*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("3ra generación de caficultores", text: $vm.generacion)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    // Ubicación
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Ubicación*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Ejido El Zapotal, Motozintla, Chiapas, México", text: $vm.ubicacion)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    // Comunidad
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Comunidad*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Plan de la Libertad (Baja), productora indígena", text: $vm.comunidad)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    // Coordenadas
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Latitud*")
                                .font(.body)
                                .foregroundColor(.black)
                            TextField("15.3631", value: $vm.latitud, format: .number)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .keyboardType(.decimalPad)
                        }
                        .frame(maxWidth: .infinity)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Longitud*")
                                .font(.body)
                                .foregroundColor(.black)
                            TextField("-92.2515", value: $vm.longitud, format: .number)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .keyboardType(.decimalPad)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Testimonio*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Aquí entre las montañas del sur, cultivamos café...", text: $vm.testimonio, axis: .vertical)
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
                            await vm.registrarProductor()
                            // limpiar selección de imagen
                            selectedImage = nil
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
    RegisterProductorView()
}

