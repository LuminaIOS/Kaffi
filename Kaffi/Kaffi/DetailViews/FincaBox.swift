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
            // IMAGEN
            AsyncImage(url: URL(string: finca.imagen)) { image in image
                    .resizable()
                    .scaledToFill()
                    .frame(width:370, height: 120)
                    .clipped()
                    .cornerRadius(5)
            } placeholder: {
                ProgressView()
                    .frame(width: 370, height: 120)
            }
            //TEXTO
            HStack(){
                VStack(alignment: .leading) {
                    Text(finca.nombre)
                        .font(.title3)
                        .bold()
                    
                    HStack {
                        Image(systemName: "mappin")
                        Text("\(finca.ciudad), \(finca.estado)")
                    }
                    .font(.subheadline)
                    
                    Text(finca.descripcion)
                        .textScale(.secondary)
                        .foregroundStyle(.secondary)
                    
                    HStack() {
                        Text("\(finca.lotes) lotes")
                            .padding(5)
                            .background(lightColor1)
                            .cornerRadius(5)
                        
                        Text("\(finca.hectareas) hectáreas")
                            .padding(5)
                            .background(lightColor2)
                            .cornerRadius(5)
                    }
                    .font(.caption)
                    
                }
                Spacer()
            }
            .padding()
            
        }
        
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.vertical,10)
        .frame(width: 370)
    }
}


#Preview{
    FincaBox(finca: Finca(nombre: "Finca solecito", ciudad: "San Cristobal", estado: "Oaxaca", descripcion: "Cafe de altisima calidad crecido en el corazon de Chiapas", hectareas: 10, lotes: 7, imagen: "https://content.elmueble.com/medio/2023/06/08/arbol-grano-cafe-frutos_83f4fed6_230608095908_900x900.jpg"))
}
