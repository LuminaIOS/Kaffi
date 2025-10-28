//
//  DisplayFincasView.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 22/10/25.
//

import SwiftUI
import SwiftData
struct DisplayFincasView: View {
    var fincasList: [Finca]=[]
    var body: some View {
        HStack(){
            NavigationLink(destination: ContentView()) {
                Spacer()
                Image(systemName: "plus.app.fill")
                Text("Registrar nueva finca")
                Spacer()
            }
            .foregroundColor(.white)
            .padding()
            .background(midColor1)
            .cornerRadius(10)
        
        }
        .padding(.horizontal)
        .padding(.vertical,10)
        
        
        ForEach(fincasList) { finca in
            FincaBox(finca: finca)
        }
        Spacer()
    }
}
#Preview {
    DisplayFincasView(fincasList: [Finca(nombre: "Finca solecito", ciudad: "San Cristobal", estado: "Oaxaca", descripcion: "Cafe de altisima calidad crecido en el corazon de Chiapas", hectareas: 10, lotes: 7, imagen: "https://content.elmueble.com/medio/2023/06/08/arbol-grano-cafe-frutos_83f4fed6_230608095908_900x900.jpg"),
        Finca(nombre: "Finca Madre Tierra", ciudad: "San Cristobal", estado: "Oaxaca", descripcion: "Cafe delisioso de Mexico al mundo", hectareas: 6, lotes: 2, imagen: "https://content.elmueble.com/medio/2023/06/08/arbol-grano-cafe-frutos_83f4fed6_230608095908_900x900.jpg")
    ])
}
