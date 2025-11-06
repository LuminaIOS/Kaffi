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
    DisplayFincasView(fincasList: [
        Finca(
            nombre_finca: "Finca Solecito",
            productor: "Juan Pérez",
            estado: "Oaxaca",
            ciudad: "San Cristóbal",
            latitud: 16.736,
            longitud: -92.637,
            hectareas: 10,
            altitud: 2100,
            suelo: "Volcánico",
            descripcion: "Café de altísima calidad crecido en el corazón de Chiapas"
        ),
        Finca(
            nombre_finca: "Finca Madre Tierra",
            productor: "María López",
            estado: "Oaxaca",
            ciudad: "San Cristóbal",
            latitud: 16.745,
            longitud: -92.642,
            hectareas: 6,
            altitud: 2050,
            suelo: "Arenoso",
            descripcion: "Café delicioso de México al mundo"
        )
    ])
}

