//
//  FincaBox.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 21/10/25.
//

import SwiftUI
struct LoteBox: View {
    let lote: Lote

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                // Image
                AsyncImage(url: URL(string: lote.imagen)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipped()
                        .cornerRadius(5)
                } placeholder: {
                    ProgressView()
                        .frame(width: 120, height: 120)
                }
                .padding(.horizontal,10)

                // Text and status
                ZStack(alignment: .topTrailing) {
                    // Status in top right
                    HStack(){
                        Text(lote.estatus)
                            .font(.caption)
                            .padding(5)
                            .background(lightColor1)
                            .cornerRadius(5)
                            .padding([.top, .trailing], 4)
                    }
                    HStack(){
                        // Main text
                        VStack(alignment: .leading, spacing: 4) {
                            Text(lote.nombre)
                                .font(.title3)
                                .bold()
                            
                            Text(lote.finca)
                                .font(.subheadline)
                            
                            HStack {
                                Image(systemName: "mappin")
                                Text("\(lote.ciudad), \(lote.estado)")
                            }
                            .font(.subheadline)
                            
                            HStack() {
                                HStack {
                                    Image(systemName: "leaf")
                                    Text(lote.cultivo)
                                }
                                .padding(5)
                                .background(lightColor1)
                                .cornerRadius(5)
                                
                                HStack {
                                    Text("\(lote.hectareas) hectáreas")
                                }
                                .padding(5)
                                .background(lightColor2)
                                .cornerRadius(5)
                            }
                            .font(.caption)
                        }
                        Spacer()
                    }
                }
            }
            .padding()
            .frame(width: 370)
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal)
        .shadow(radius: 5)
    }
}


#Preview{
    LoteBox(lote: Lote(nombre: "Lote-B2", finca: "El Paraíso", ciudad: "San Cristobal", estado: "Oaxaca", cultivo: "Caña", hectareas: 10, estatus: "En produccion", imagen: "https://content.elmueble.com/medio/2023/06/08/arbol-grano-cafe-frutos_83f4fed6_230608095908_900x900.jpg"))
}
