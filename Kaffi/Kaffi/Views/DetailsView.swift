//
//  DetailsView.swift
//  Kaffi
//
//  Created by Alumno on 05/11/25.
//

import SwiftUI
import SwiftData

struct DetailsView: View {
    var lote: Lote

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                AsyncImage(url: URL(string: lote.imagen)) { image in
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

                VStack(spacing: 12) {
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
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)

                VStack {
                    Text("Mapa del lote")
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

                VStack(spacing: 12) {
                    Text("Características del café")
                        .font(.headline)
                    HStack{
                        VStack {
                            Label("1,500 msnm", systemImage: "mountain.2.fill")
                            Spacer()
                            Label("Arábica Typica", systemImage: "leaf.fill")
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

                VStack(alignment: .leading, spacing: 12) {
                    Text("Prácticas sostenibles")
                        .font(.headline)
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
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGreen).opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
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
        }
        .navigationTitle("Detalles del producto")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    DetailsView(
        lote: Lote(
            nombre: "Lote Santa Fé 3",
            finca: "Finca Santa Fé",
            ciudad: "Motozintla",
            estado: "Chiapas",
            cultivo: "cafe ",
            hectareas: 12,
            estatus: "listo",
            imagen: "https://upload.wikimedia.org/wikipedia/commons/4/45/A_small_cup_of_coffee.JPG",
            
        )
    )
}
