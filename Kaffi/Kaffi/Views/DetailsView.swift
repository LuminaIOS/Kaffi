//
//  DetailsView.swift
//  Kaffi
//

import SwiftUI
import SwiftData
import MapKit

struct DetailsView: View {
    let lote: Lote
    @State private var viewModel = LoteDetailViewModel()
    
    var body: some View {
        ScrollView {
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
                        )
                    )
                    .overlay(
                        VStack(alignment: .leading) {
                            Spacer()
                            Text(detail.lote.nombre)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Text(detail.lote.nombre_finca)
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
                if let finca = detail.finca {
                    HStack {
                        Label {
                            Text(finca.productor)
                        } icon: {
                            Image(systemName: "person.fill")
                                .foregroundColor(.brown)
                        }
                        Spacer()
                    }
                    HStack {
                        Label {
                            Text("\(finca.ciudad), \(finca.estado)")
                        } icon: {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
            
            
            if let finca = detail.finca {
                let fincalocation = CLLocationCoordinate2D(latitude: finca.latitud, longitude: finca.longitud)
                VStack {
                    Text("Ubicación de la finca")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.bottom, 4)
                    Map(position: .constant(
                                MapCameraPosition.region(
                                    MKCoordinateRegion(
                                        center: fincalocation,
                                        span: MKCoordinateSpan(
                                            latitudeDelta: 12,
                                            longitudeDelta: 12
                                        )
                                    )
                                )
                            )) {
                                Marker("", coordinate: fincalocation)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 14))

                            .frame(width: 300, height: 200)
                    Text("\(String(format: "%.4f", finca.latitud)), \(String(format: "%.4f", finca.longitud))")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGreen).opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            VStack(spacing: 12) {
                Text("Características del lote")
                    .font(.headline)
                
                HStack{
                    VStack(alignment: .leading, spacing: 8) {
                        if let finca = detail.finca {
                            Label("\(Int(finca.altitud)) msnm", systemImage: "mountain.2.fill")
                        }
                        
                        
                        Label(detail.lote.cultivo, systemImage: "leaf.fill")
                    }
                    .font(.subheadline)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Label("\(detail.lote.hectareas) hectáreas", systemImage: "square.grid.2x2")
                        Label(detail.lote.estatus, systemImage: "chart.bar")
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
                
                if !detail.practicasSostenibles.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(detail.practicasSostenibles, id: \.self) { practica in
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
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)

        

        }
        .padding(.horizontal)
        .padding(.bottom, 30)
    }
}

#Preview {
    DetailsView(
        lote: Lote(
            id_lote: 1,
            id_usuario: "testing-1",
            id_finca: 1,
            nombre_finca: "Finca Guacamaya",
            nombre: "Lote-B2",
            cultivo: "Java",
            hectareas: 1,
            estatus: "En produccion",
            imagen: "https://content.elmueble.com/medio/2023/06/08/arbol-grano-cafe-frutos_83f4fed6_230608095908_900x900.jpg"
        )
    )
}
