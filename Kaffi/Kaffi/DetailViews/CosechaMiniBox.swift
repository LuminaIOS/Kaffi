//
//  CosechaMiniBox.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 04/12/25.
//

import SwiftUI
struct CosechaMiniBox: View {
    let cosecha: Cosecha
    var body: some View {
        VStack{
            HStack{
                Text(cosecha.inicio_cosecha!)
                Text("-")
                Text(cosecha.fin_cosecha!)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            //            HStack(){
//                AsyncImage(url: URL(string: cosecha.imagen_cosecha ?? "https://cafeab.com/files/articles/image/1683892785-granos-de-cafe.png")) { image in
//                    image
//                        .resizable()
//                        .scaledToFill()
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 50)
//                        .clipped()
//                        .cornerRadius(10)
//                } placeholder: {
//                    Color.gray
//                        .scaledToFill()
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 50)
//                        .clipped()
//                        .cornerRadius(10)
//                }
//            }
//            .padding(10)
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal)
        .shadow(radius: 5)
    }
}
#Preview{
    CosechaMiniBox(cosecha: Cosecha(
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
        agua_riego: 2,
        agua_huella: "4",
        id_usuario: "1",
        id_finca: 42,
        id_coop: 2,
        puntaje_catacion: 8.7,
        perfil_sensorial: "Notas de cacao",
        empaque: "Bolsas ecologicas",
        contenido_nutricional: "100mg de cafeina",
        imagen_cosecha: "https://cafeab.com/files/articles/image/1683892785-granos-de-cafe.png"))
    
}

