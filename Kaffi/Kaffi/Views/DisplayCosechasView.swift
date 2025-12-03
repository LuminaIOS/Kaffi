//
//  DisplayCosechasView.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 21/10/25.
//
import SwiftUI

struct DisplayCosechasView: View {
        @State private var vm = CosechaViewModel(cosechaService: CosechaService(), supabase: client)
        let supabase = client
        var body: some View {
            VStack(){
                
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
                            ForEach(vm.cosechas) { cosecha in
                                NavigationLink(destination: CosechaDetailView(cosecha: cosecha)){
                                CosechaBox(cosecha: cosecha)
                                }
                                .buttonStyle(.plain)
                                
                            }
                        }
                        .padding()
                    }
                }
                Spacer()
            }.task {
                do{
                    await vm.fetchCosechas()
                }
                
            }
        }
    }

    #Preview {
        DisplayCosechasView()
    }
