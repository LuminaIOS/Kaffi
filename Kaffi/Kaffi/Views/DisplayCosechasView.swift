//
//  DisplayCosechasView.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 21/10/25.
//
import SwiftUI

struct DisplayCosechasView: View {
    @State private var vm = CosechaSearchViewModel(
        cosechaService: CosechaService(),
        fincaService: FincaService(),
        supabase: client
    )
    
    @State private var searchText = ""
    
    var filteredCosechas: [Cosecha] {
        if searchText.isEmpty {
            return vm.cosechas
        }
        
        return vm.cosechas.filter { cosecha in
            if let finca = vm.fincas.first(where: { $0.id_finca == cosecha.id_finca }) {
                return finca.nombre_finca.lowercased().contains(searchText.lowercased())
            }
            return false
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if vm.isLoading {
                    ProgressView("Cargando cosechas...")
                } else if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(filteredCosechas) { cosecha in
                                NavigationLink(destination: CosechaDetailView(cosecha: cosecha)) {
                                    CosechaBox(cosecha: cosecha)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Cosechas")
            .searchable(text: $searchText, prompt: "Buscar por nombre de finca")
            .task {
                await vm.fetchForSearch()
            }
        }
    }
}


#Preview {
    DisplayCosechasView()
}
