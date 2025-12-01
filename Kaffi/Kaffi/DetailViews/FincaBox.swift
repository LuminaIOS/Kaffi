//
//  FincaBox.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 22/10/25.
//

import SwiftUI
struct FincaBox: View {
    let finca: Finca
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: finca.imagen ?? "https://perfectdailygrinnd.com/es/wp-content/uploads/sites/2/2021/01/Lotes-de-Cafe%CC%81-3.jpg")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width:300, height: 120)
                    .clipped()
                    .cornerRadius(10)
            } placeholder: {
                Color.gray
                    .scaledToFill()
                    .frame(width:300, height: 120)
                    .clipped()
                    .cornerRadius(10)
            }
            .padding(5)
            HStack(){
                VStack(alignment: .leading) {
                    Text(finca.nombre_finca)
                        .font(.title3)
                        .bold()
//                    
//                    HStack {
//                        Image(systemName: "mappin")
//                        Text("\(finca.ciudad), \(finca.estado)")
//                    }
//                    .font(.subheadline)
//                    
//                    Text(finca.descripcion)
//                        .textScale(.secondary)
//                        .foregroundStyle(.secondary)
                    
                    HStack() {
                        Text("\(finca.hectareas) hectáreas")
                            .padding(5)
                            .background(lightColor2)
                            .cornerRadius(5)
                    }
                    .font(.caption)
                    
                }
                Spacer()
            }
            
        }
        .padding()
        
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
        .frame(width: 320)
    }
}



#Preview {
    FincaBox(
        finca: Finca(
            id_finca: 1,
            id_usuario: "usuario1",
            //fecha_creacion: Date(1000000000),
            nombre_finca: "Finca Solecito",
            productor: 1,
            hectareas: 10,
            altitud: 1.2,
            variedades_cult: "Bourbon, Typica",
            porte_planta: "Medio",
            imagen: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQP8PnhM1MNuiVPyxVkOFg45Vd1c3svVWwL8w&s",
            id_coop: 1,
            lote: ["A123", "A124", "A126"],
            //sombra_natural = 10,
            especies: "Muchas",
            arboles_mayores: 0
        )
    )
}
