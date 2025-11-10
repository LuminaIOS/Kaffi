//
//  DisplayLotesView.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 21/10/25.
//
import SwiftUI

struct DisplayLotesView: View {
    @StateObject private var loteService = LoteService()
    var body: some View {
        VStack(){
            HStack {
                NavigationLink(destination: RegisterFincaView()) {
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
            .padding(.vertical, 10)
            
            if loteService.isLoading {
                ProgressView("Cargando lotes...")
                    .padding()
            } else if let error = loteService.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(loteService.lotes) { lote in
                            NavigationLink(destination: DetailsView(lote: lote)){
                                LoteBox(lote: lote)
                            }
                            .buttonStyle(.plain)

                        }
                    }
                    .padding()
                }
            }
            Spacer()
        }.task {
            await loteService.fetchLotes()
        }
    }
}

#Preview {
    DisplayLotesView()
}
