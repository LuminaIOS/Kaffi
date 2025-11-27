//
//  RecordatorioBox.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 17/11/25.
//

import SwiftUI
struct RecordatorioBox: View {
    let recordatorio: Recordatorio
    @StateObject private var recService = RecordatorioService()
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                Text(recordatorio.texto)
                    .multilineTextAlignment(.leading)
            }
            .padding(8)
            Spacer()
            //Boton de borrar
            Button(action: {
                Task {
                    await recService.deleteRecordatorio(recordatorio)
                }})
            {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .padding(.horizontal, 20)
            }
        }
        .frame(width: 320, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 2)
        )
        .background(Color(white: 0.96))
        .padding(3)
    }
}


#Preview{
    RecordatorioBox(recordatorio: Recordatorio(id_recordatorio: 1, id_usuario: "test", texto: "Este es un test"))
}
