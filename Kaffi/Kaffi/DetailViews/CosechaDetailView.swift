//
//  CosechaDetailView.swift
//  KaffiHelper
//
//  Created by Amparo Alcaraz Tonella on 02/12/25.
//

import SwiftUI

struct CosechaDetailView: View {
    let cosecha: Cosecha
    @State private var viewModel = FincaViewModel(fincaService: FincaService(), supabase: client)

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                AsyncImage(url: URL(string: cosecha.imagen_cosecha ?? "https://cafeab.com/files/articles/image/1683892785-granos-de-cafe.png")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipped()
                        .overlay(
                            LinearGradient(colors: [.black.opacity(0.3), .clear], startPoint: .top, endPoint: .bottom)
                        )
                } placeholder: {
                    Color.gray.frame(height: 180)
                }

                VStack(spacing: 4) {
                    if let finca = viewModel.fincaByID {
                                    Text(finca.nombre_finca)
                            .font(.title)
                            .font(.headline)
                                } else if viewModel.isLoading {
                                    ProgressView()
                                } else {
                                    Text("No se encontro finca")
                                        .font(.title)
                                        .font(.headline)
                                } 
                    Text("\(cosecha.inicio_cosecha ?? "") — \(cosecha.fin_cosecha ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
               

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("Calidad y Producto Final")
                            .font(.headline)
                    }
                    if let puntaje = cosecha.puntaje_catacion {
                        Text("Puntaje de Catación: \(String(format: "%.1f", puntaje))/10")
                            .font(.title3)
                            .bold()
                    }
                    Text("Perfil Sensorial: \(cosecha.perfil_sensorial ?? "No disponible")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                
                HStack{
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green)
                            Text("Huella de Carbono")
                            .font(.headline)
                            }
                        let creadas = cosecha.emisiones_carbono ?? 0
                        let capturadas = cosecha.emisiones_captura ?? 0
                        let netas = creadas + capturadas
                                
                        Text("\(String(format: "%.2f", netas)) kg CO₂e/kg netas")
                            .font(.title3)
                            .bold()
                        Text("Emisiones creadas: \(String(format: "%.2f", creadas)) kg CO₂e/kg")
                            .font(.subheadline)
                        Text("Emisiones capturadas: \(String(format: "%.2f", capturadas)) kg CO₂e/kg")
                            .font(.subheadline)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))

                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "drop.fill")
                                        .foregroundColor(.blue)
                                    Text("Huella Hídrica")
                                        .font(.headline)
                                }
                                Text("\(cosecha.agua_huella ?? "0") kg CO₂e/kg netas")
                                    .font(.title3)
                                    .bold()
                                Text("Emisiones creadas: \(String(format: "%.2f", cosecha.agua_beneficio ?? 0)) L/kg")
                                    .font(.subheadline)
                                Text("Emisiones capturadas: \(String(format: "%.2f", cosecha.agua_riego ?? 0)) L/kg")
                                    .font(.subheadline)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                }
                

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "bag.fill")
                            .foregroundColor(.pink)
                        Text("Sobre el producto")
                            .font(.headline)
                        Spacer()
                    }
                    Text("Empaque: \(cosecha.empaque ?? "No disponible")")
                        .font(.subheadline)
                    Text("Cafeína: \(cosecha.contenido_nutricional ?? "No disponible")")
                        .font(.subheadline)
                }

                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "leaf.circle.fill")
                            .foregroundColor(.orange)
                        Text("Sobre la cosecha")
                            .font(.headline)
                    }
                    Text("Volumen de cosecha: \(cosecha.volumen ?? "No disponible")")
                        .font(.subheadline)
                    Text("Método: \(cosecha.procesamiento ?? "No disponible")")
                        .font(.subheadline)
                    if let dias = cosecha.fermentacion {
                        Text("Fermentado: \(dias) días")
                            .font(.subheadline)
                    }
                    Text("Secado: \(cosecha.secado ?? "No disponible")")
                        .font(.subheadline)
                    Text("Subproductos: \(cosecha.subproductos ?? "No disponible")")
                        .font(.subheadline)
                    Text("Tratamiento de agua: \(cosecha.tratamiento_agua ?? "No disponible")")
                        .font(.subheadline)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
            }
            .padding()
        }
        .task {
            if let fincaID = cosecha.id_finca {
                do {
                    try await viewModel.getFincaByID(fincaID)
                } catch {
                    print("Error fetching finca:", error)
                }
            }
        }
    }
}



#Preview{
    CosechaDetailView(cosecha: Cosecha(
        id_cosecha: 2,
        created_at: Date(timeIntervalSinceNow: 0),
        volumen: "27 quintales de pergamino",
        inicio_cosecha: "Noviembre 2024",
        fin_cosecha: "Febrero 2024",
        procesamiento: "Lavado Ecologico",
        fermentacion: 18,
        secado: "Camas africanas",
        subproductos: "Pulpa",
        tratamiento_agua: "Filtro",
        emisiones_carbono: 2.08,
        emisiones_captura: -2,
        emisiones_neto: 0.08,
        agua_beneficio: 2,
        agua_riego: -2,
        agua_huella: "4",
        id_usuario: "1",
        id_finca: 42,
        id_coop: 2,
        puntaje_catacion: 8.7,
        perfil_sensorial: "Notas de cacao",
        empaque: "Bolsas ecologicas",
        contenido_nutricional: "100mg de cafeina",
        imagen_cosecha: "https://cafeab.com/files/articles/image/1683892785-granos-de-cafe.png"),
                      
        )
}

