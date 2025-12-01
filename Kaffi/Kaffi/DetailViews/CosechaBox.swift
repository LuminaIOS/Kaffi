//
//  CosechaBox.swift
//  Kaffi
//
//  Created by Amparo on 01/12/25.
//

import SwiftUI
struct CosechaBox: View {
    let cosecha: Cosecha
    var body: some View {
        VStack {
            HStack{
                Text(cosecha.volumen!)
                    .padding(5)
                    .background(lightColor1)
                    .cornerRadius(5)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding(.horizontal)
        .shadow(radius: 5)
    }
}
#Preview{
    CosechaBox(cosecha: Cosecha(
        id_cosecha: 2,
        created_at: Date(timeIntervalSinceNow: 0),
        volumen: "String? = nil",
        inicio_cosecha: "String? = nil",
        fin_cosecha: "String? = nil",
        procesamiento: "tring? = nil",
        fermentacion: 2,
        secado: "String? = nil",
        subproductos: "tring? = nil",
        tratamiento_agua: "String? = nil",
        emisiones_carbono: 2,
        emisiones_captura: 2,
        emisiones_neto: 2,
        agua_beneficio: 2,
        agua_riego: 2,
        agua_huella: "String? = nil",
        id_usuario: "String? = nil",
        id_finca: 2,
        id_coop: 2,
        puntaje_catacion: 2,
        perfil_sensorial: "",
        empaque: "carton",
        contenido_nutricional: "String? = nil",
        imagen_cosecha: "String? = nil"))
    
}
