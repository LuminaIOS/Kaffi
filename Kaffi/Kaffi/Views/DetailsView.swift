//
//  DetailsView.swift
//  Kaffi
//
//  Created by Alumno on 05/11/25.
//

import SwiftUI
import SwiftData

struct DetailsView: View {
    var finca: Finca

    var body: some View {
        ScrollView {
<<<<<<< Updated upstream
            VStack(alignment: .leading, spacing: 20) {
                
                AsyncImage(url: URL(string: finca.imagen)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            LinearGradient(
                                colors: [.black.opacity(0.0), .black.opacity(0.5)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
=======
            if viewModel.isLoading {
                ProgressView("Cargando detalles...")
                    .padding()
            } else if let error = viewModel.errorMessage {
                ContentUnavailableView(
                    "Error al cargar",
                    systemImage: "exclamationmark.triangle",
                    description: Text(error)
                )
                .padding()
            } else if let detail = viewModel.loteDetail {
                contenidoDetallado(detail: detail)
            } else {
                ContentUnavailableView(
                    "No hay datos",
                    systemImage: "questionmark.circle",
                    description: Text("No se pudieron cargar los detalles del lote")
                )
                .padding()
            }
        }
        .navigationTitle("Detalles del Lote")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .task {
            await viewModel.cargarDetalles(lote: lote)
        }
    }
    
    @ViewBuilder
    private func contenidoDetallado(detail: LoteDetail) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            AsyncImage(url: URL(string: detail.lote.imagen ?? detail.finca?.imagen ?? "https://perfectdailygrind.com/es/wp-content/uploads/sites/2/2021/01/Lotes-de-Cafe%CC%81-3.jpg")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        LinearGradient(
                            colors: [.black.opacity(0.0), .black.opacity(0.5)],
                            startPoint: .top,
                            endPoint: .bottom
>>>>>>> Stashed changes
                        )
                        .overlay(
                            VStack(alignment: .leading) {
                                Spacer()
                                Text("Café Santa Fé")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                Text("Finca Santa Fé")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 12),
                            alignment: .bottomLeading
                        )
                } placeholder: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray5))
                        .frame(height: 180)
                }

<<<<<<< Updated upstream
                VStack(spacing: 12) {
=======
            VStack(spacing: 12) {
                if let finca = detail.finca {
>>>>>>> Stashed changes
                    HStack {
                        Label {
                            Text("Gilberto García")
                        } icon: {
                            Image(systemName: "person.fill")
                                .foregroundColor(.brown)
                        }
                        Spacer()
                    }
                    HStack {
                        Label {
                            Text("Motozintla, Chiapas")
                        } icon: {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                }
<<<<<<< Updated upstream
=======
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
            
            if let descripcion = detail.finca?.descripcion, !descripcion.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Descripción")
                        .font(.headline)
                    Text(descripcion)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
>>>>>>> Stashed changes
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
<<<<<<< Updated upstream

=======
                
            }


            if let finca = detail.finca {
>>>>>>> Stashed changes
                VStack {
                    Text("Mapa de la finca")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.bottom, 4)
                    Text("15.3654, -92.2478")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGreen).opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 14))

<<<<<<< Updated upstream
                VStack(spacing: 12) {
                    Text("Características del café")
                        .font(.headline)
                    HStack{
                        VStack {
                            Label("1,500 msnm", systemImage: "mountain.2.fill")
                            Spacer()
                            Label("Arábica Typica", systemImage: "leaf.fill")
=======
            VStack(spacing: 12) {
                Text("Características del lote")
                    .font(.headline)
                
                HStack{
                    VStack(alignment: .leading, spacing: 8) {
                        if let finca = detail.finca {
                            Label("\(Int(finca.altitud)) msnm", systemImage: "mountain.2.fill")
>>>>>>> Stashed changes
                        }
                        Spacer()
                        .font(.subheadline)
                        VStack {
                            Label("Lavado", systemImage: "drop.fill")
                            Spacer()
                            Label("Enero 2025", systemImage: "calendar")
                        }
                        .font(.subheadline)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)

<<<<<<< Updated upstream
                VStack(alignment: .leading, spacing: 12) {
                    Text("Prácticas sostenibles")
                        .font(.headline)
=======

            VStack(alignment: .leading, spacing: 12) {
                Text("Prácticas sostenibles")
                    .font(.headline)
                
                if !detail.practicasSostenibles.isEmpty {
>>>>>>> Stashed changes
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach([
                            "Cultivo orgánico certificado",
                            "Sombra natural con árboles nativos",
                            "Conservación de suelos",
                            "Uso eficiente del agua",
                            "Comercio justo",
                            "Biodiversidad protegida"
                        ], id: \.self) { practica in
                            HStack(spacing: 10) {
                                Image(systemName: "leaf.circle.fill")
                                    .foregroundColor(.green)
                                Text(practica)
                                    .font(.subheadline)
                                Spacer()
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGreen).opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                } else {
                    HStack {
                        Image(systemName: "leaf.circle")
                            .foregroundColor(.gray)
                        Text("No hay prácticas sostenibles registradas")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(15)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
<<<<<<< Updated upstream
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)

                HStack(spacing: 12) {
                    Button {
                    } label: {
                        Text("Volver al inicio")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.brown)

                    Button {
                    } label: {
                        Text("Escanear otro")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 10)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
=======
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)

    
            

         
>>>>>>> Stashed changes
        }
        .navigationTitle("Detalles del producto")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    DetailsView(
        finca: Finca(
            usuario: "usuario1",
            nombre: "Finca Santa Fé",
            ciudad: "Motozintla",
            estado: "Chiapas",
            descripcion: "Café de alta calidad cultivado en el corazón de Chiapas.",
            hectareas: 12,
            imagen: "https://upload.wikimedia.org/wikipedia/commons/4/45/A_small_cup_of_coffee.JPG",
            latitud: 15.3654,
            longitud: -92.2478,
            altitud: 1500
        )
    )
}
