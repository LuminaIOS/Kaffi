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
        VStack{
            HStack(){
                AsyncImage(url: URL(string: cosecha.imagen_cosecha ?? "https://cafeab.com/files/articles/image/1683892785-granos-de-cafe.png")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                } placeholder: {
                    Color.gray
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                }
            }
            VStack {
                VStack{
                    if let finca = viewModel.fincaByID {
                        Text(finca.nombre_finca)
                            .font(.title)
                            .font(.headline)
                    } else if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("No se encontro finca")
                            .font(.headline)
                    }
                }
                .padding(5)
                HStack{
                    Text("Cosecha de")
                    Text(cosecha.inicio_cosecha!)
                    Text("-")
                    Text(cosecha.fin_cosecha!)
                }
                .font(.subheadline)
                .padding(.horizontal, 20)
                .padding(.vertical, 2)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                VStack(alignment: .leading){
                    HStack{
                        Image(systemName:"star.fill")
                            .foregroundColor(.yellow)
                        Text("Calidad y Producto Final")
                            .font(.headline)
                    }
                    VStack(alignment: .leading){
                        if let puntaje = cosecha.puntaje_catacion {
                            Text("Puntaje de catación: \(String(format: "%.2f", puntaje))/10")
                        } else {
                            Text("Puntaje de catación: No disponible")
                        }
                        Text("Perfil sensorial: \(cosecha.perfil_sensorial ?? "Perfil sensorial no disponible")")
                        
                        
                    }
                    .padding(.horizontal, 15)
                }
                .padding(5)
                
                
                
                VStack(alignment: .leading){
                    //Emisiones de carbono
                    if let emisiones = cosecha.emisiones_carbono,
                       let emisiones2 = cosecha.emisiones_captura{
                        HStack{
                            Image(systemName:"leaf.fill")
                                .foregroundColor(.green)
                            Text("Huella de Carbono")
                                .font(.headline)
                        }
                        VStack(alignment: .leading){
                            Text("Emisiones creadas: \(String(format: "%.2f", emisiones)) kg CO₂e/kg")
                            Text("Emisiones capturadas: \(String(format: "%.2f", emisiones2)) kg CO₂e/kg")
                            Text("Emisiones netas: \(String(format: "%.2f", (emisiones+emisiones2))) kg CO₂e/kg")
                        }
                        .padding(.horizontal, 15)
                    }
                }
                .padding(5)
                
                VStack(alignment: .leading){
                    if let aguab = cosecha.agua_beneficio,
                       let aguar = cosecha.agua_riego{
                        HStack{
                            Image(systemName:"drop.fill")
                                .foregroundColor(.blue)
                            Text("  Huella Hídrica")
                                .font(.headline)
                            Spacer()
                        }
                        VStack(alignment: .leading){
                            Text("Emisiones creadas: \(String(format: "%.2f", aguab))L/kg")
                            Text("Emisiones capturadas: \(String(format: "%.2f", aguar)) L/kg")
                            Text("Emisiones netas: \(String(format: "%.2f", (aguab+aguar))) kg CO₂e/kg")
                        }
                        .padding(.horizontal, 15)
                    }
                }
                .padding(5)
                
                VStack(alignment: .leading){
                    HStack{
                        Image(systemName:"message.fill")
                            .foregroundColor(.pink)
                        Text("Sobre el producto")
                            .font(.headline)
                    }
                    VStack(alignment: .leading){
                        Text("Empaque: \(cosecha.empaque ?? "Empaque no disponible")")
                        Text("Contenido nutricional: \(cosecha.contenido_nutricional ?? "Contenido nutricional no disponible")")
                    }
                    .padding(.horizontal, 15)
                }
                .padding(5)
                
                VStack(alignment: .leading){
                    HStack{
                        Image(systemName:"star.fill")
                            .foregroundColor(.yellow)
                        Text("Sobre la cosecha")
                            .font(.headline)
                    }
                    VStack(alignment: .leading){
                        Text("Volumen de cosecha: \(cosecha.volumen ?? "Volumen no disponible")")
                        Text("Método de procesamiento: \(cosecha.procesamiento ?? "Procesamiento no disponible")")
                        if let dias = cosecha.fermentacion {
                            Text("Fermentado por \(dias) días")
                        } else {
                            Text("Fermentación no disponible")
                        }
                        Text("Secado: \(cosecha.secado ?? "Secado no disponible")")
                        Text("Subproductos: \(cosecha.subproductos ?? "Subproductos no disponible")")
                        Text("Tratamiento de agua: \(cosecha.tratamiento_agua ?? "Tratamiento de agua no disponible")")
                    }
                    .padding(.horizontal, 15)
                    
                }
                .padding(5)
                
            }
            
        }
            .padding()
        Spacer()
            .task {
                if let fincaID = cosecha.id_finca {
                    await viewModel.getFincaByID(fincaID)
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

