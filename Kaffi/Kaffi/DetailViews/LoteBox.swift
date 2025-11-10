//
//  FincaBox.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 21/10/25.


import SwiftUI
struct LoteBox: View {
    let lote: Lote
    var body: some View {
        VStack {
            HStack(alignment: .top) {
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
                            
                            Text("\(lote.nombre_finca)")
                                .font(.subheadline)
                            Spacer()
                            HStack() {
                                Spacer()
                                HStack {
                                    Image(systemName: "leaf")
                                    Text(lote.cultivo)
                                }
                                .padding(5)
                                .background(lightColor1)
                                .cornerRadius(5)
                                .font(.caption)
                                
                                HStack {
                                    Text("\(lote.hectareas) hectáreas")
                                }
                                .padding(5)
                                .background(lightColor2)
                                .cornerRadius(5)
                                .font(.caption)
                            }
                        }
                        .padding(.horizontal, 5)
                        Spacer()
                    }
                }
            }
            .padding()
            .frame(width: 320, height: 120)
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal)
        .shadow(radius: 5)
    }
}


#Preview{
    LoteBox(lote: Lote(id_lote:1, id_usuario:"testing-1", id_finca: 2, nombre_finca:"Finca La Luna", nombre: "Lote-B2", cultivo: "Java", hectareas: 1, estatus: "En produccion", imagen: "https://content.elmueble.com/medio/2023/06/08/arbol-grano-cafe-frutos_83f4fed6_230608095908_900x900.jpg"))
}
