

import SwiftUI
import SwiftData
import PhotosUI

struct RegisterFarmView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var nombreFinca: String = ""
    @State private var productor: String = ""
    @State private var ubicacion: String = ""
    @State private var latitud: String = ""
    @State private var longitud: String = ""
    @State private var hectareas: String = ""
    @State private var altitud: String = ""
    @State private var tipoSuelo: String = ""
    @State private var descripcion: String = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var imagenURL: String = ""

    let tiposDeSuelo = ["Selecciona el tipo de suelo", "Arcilloso", "Arenoso", "Limoso", "Franco", "Volcánico", "Calizo"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text("Registrar Finca")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                // Image Upload
                VStack {
                    if imagenURL.isEmpty {
                        Button(action: {
                            // Image upload action
                        }) {
                            VStack {
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 50))
                                    .foregroundStyle(Color.gray)

                                Text("Foto de la finca")
                                    .font(.headline)
                                    .foregroundStyle(Color.black)

                                Text("Toca para subir una foto")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                            .frame(width: 350, height: 200)
                            .background(Color.lightColor2.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                    .foregroundStyle(Color.gray)
                            )
                        }
                    } else {
                        AsyncImage(url: URL(string: imagenURL)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 350, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal)

                // Form Fields
                VStack(spacing: 15) {
                    // Nombre de la finca
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Nombre de la finca *")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        TextField("Ej: Finca Santa Fe", text: $nombreFinca)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    // Productor
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Productor *")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        TextField("Ej: Gilberto García", text: $productor)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    // Ubicación
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Ubicación *")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        TextField("Ej: Motozintla, Chiapas", text: $ubicacion)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    // Latitud y Longitud
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Latitud *")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            TextField("15.3654", text: $latitud)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }

                        VStack(alignment: .leading, spacing: 5) {
                            Text("Longitud *")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            TextField("-92.2478", text: $longitud)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                    }

                    // Hectáreas
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Hectáreas *")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        TextField("0.0", text: $hectareas)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.decimalPad)
                    }

                    // Altitud
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Altitud (msnm) *")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        TextField("1500", text: $altitud)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }

                    // Tipo de suelo
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Tipo de suelo *")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Picker("Tipo de suelo", selection: $tipoSuelo) {
                            ForEach(tiposDeSuelo, id: \.self) { tipo in
                                Text(tipo).tag(tipo)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(height: 40)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }

                    // Descripción
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Descripción *")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        TextEditor(text: $descripcion)
                            .frame(height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal)

                // Register Button
                Button(action: {
                    registrarFinca()
                }) {
                    Text("Registrar finca")
                        .font(.headline)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.midColor2)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
                .disabled(!isFormValid)
                .opacity(isFormValid ? 1.0 : 0.6)
            }
        }
        .background(Color.white.opacity(0.95))
    }

    private var isFormValid: Bool {
        !nombreFinca.isEmpty &&
        !productor.isEmpty &&
        !ubicacion.isEmpty &&
        !latitud.isEmpty &&
        !longitud.isEmpty &&
        !hectareas.isEmpty &&
        !altitud.isEmpty &&
        tipoSuelo != "Selecciona el tipo de suelo" &&
        !descripcion.isEmpty
    }

    private func registrarFinca() {
        // Parse location (assuming format: "Ciudad, Estado")
        let locationComponents = ubicacion.components(separatedBy: ", ")
        let ciudad = locationComponents.first ?? ubicacion
        let estado = locationComponents.count > 1 ? locationComponents[1] : ""

        let nuevaFinca = Finca(
            id: UUID(),
            usuario: productor,
            nombre: nombreFinca,
            ciudad: ciudad,
            estado: estado,
            descripcion: descripcion,
            hectareas: Int(hectareas) ?? 0,
            imagen: imagenURL.isEmpty ? "https://via.placeholder.com/400" : imagenURL,
            latitud: Double(latitud) ?? 0.0,
            longitud: Double(longitud) ?? 0.0,
            altitud: Double(altitud) ?? 0.0
        )

        modelContext.insert(nuevaFinca)
        dismiss()
    }
}

#Preview {
    RegisterFarmView()
        .modelContainer(for: Finca.self)
}
