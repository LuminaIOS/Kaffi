//
//  DisplayLotesView.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 21/10/25.
//


import SwiftUI
import SwiftData
struct DisplayLotesView: View {
    var loteList: [Lote]=[]
    var body: some View {
        HStack(){
            NavigationLink(destination: ContentView()) {
                Spacer()
                Image(systemName: "plus.app.fill")
                Text("Registrar nuevo lote")
                Spacer()
            }
            .foregroundColor(.white)
            .padding()
            .background(midColor1)
            .cornerRadius(10)
        
        }
        .padding(.horizontal)
        .padding(.vertical,10)
        
        
        ForEach(loteList) { lote in
            LoteBox(lote: lote)
        }
        Spacer()
    }
}

#Preview {
    DisplayLotesView(loteList: [
        Lote(nombre: "Lote-B1", finca: "La Esperanza", ciudad: "Motozintla", estado: "Chiapas", cultivo: "Café", hectareas: 5, estatus: "En produccion",imagen: "https://content.elmueble.com/medio/2023/06/08/arbol-grano-cafe-frutos_83f4fed6_230608095908_900x900.jpg"),
        Lote(nombre: "Lote-B2", finca: "El Paraíso", ciudad: "San Cristobal", estado: "Inactivo", cultivo: "Caña", hectareas: 10, estatus: "En produccion",imagen: "https://content.elmueble.com/medio/2023/06/08/arbol-grano-cafe-frutos_83f4fed6_230608095908_900x900.jpg")
    ])
}
