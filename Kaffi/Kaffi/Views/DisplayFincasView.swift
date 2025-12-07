//
//  DisplayFincasView.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 22/10/25.
//
import SwiftUI

struct DisplayFincasView: View {
    @State private var vm = FincaViewModel(fincaService: FincaService(), supabase: client)
    @State private var searchText = ""
    var filteredFincas: [Finca] {
        if searchText.isEmpty {
            return vm.fincas
        }
        return vm.fincas.filter { finca in
            finca.nombre_finca.lowercased().contains(searchText.lowercased())
        }
    }
    var body: some View {
        ScrollView{
            VStack{
                if vm.isLoading {
                    ProgressView("Cargando fincas...")
                        .padding()
                } else if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(filteredFincas) { finca in
                                NavigationLink(destination: FincaDetailView(finca: finca)){
                                    FincaBox(finca: finca)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Buscar finca…")
            .task {
                do{
                    try await vm.fetchFincas()
                }catch{
                    print(vm.errorMessage)
                }
                
            }
        }
    }
}

#Preview {
    DisplayFincasView()
}
