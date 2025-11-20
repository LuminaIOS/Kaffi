//
//  DisplayLotesView.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 21/10/25.
//
import SwiftUI

struct DisplayLotesView: View {
    @State private var vm = LoteViewModel(LoteService: LoteService(), supabase: client)
    let supabase = client
    var body: some View {
        VStack(){
            HStack {
                NavigationLink(destination: RegisterFincaView()) {
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
            .padding(.vertical, 10)
            
            if vm.isLoading {
                ProgressView("Cargando lotes...")
                    .padding()
            } else if let error = vm.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(vm.lotes) { lote in
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
            await vm.fetchLotes()
        }
    }
}

#Preview {
    DisplayLotesView()
}
