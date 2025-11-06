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
            //AsyncImage(url: URL(string: finca.imagen)) { image in image
                    //.resizable()
            //.scaledToFill()
            //.frame(width:370, height: 120)
            //.clipped()
            //.cornerRadius(5)
            //} placeholder: {
            //ProgressView()
            //.frame(width: 370, height: 120)
            //}
            //TEXTO
            HStack(){
                VStack(alignment: .leading) {
                    Text(finca.nombre_finca)
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


#Preview {
    FincaBox(
        finca: Finca(
            nombre_finca: "Finca Solecito",
            productor: "usuario1",
            estado: "Oaxaca",
            ciudad: "San Cristóbal",
            latitud: 1.2,
            longitud: 1.2,
            hectareas: 10,
            altitud: 1.2,
            suelo: "Volcánico",
            descripcion: "Café de altísima calidad crecido en el corazón de Chiapas"
        )
    )
}

