//
//  DisplayFincasView.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 22/10/25.
//
import SwiftUI

struct DisplayFincasView: View {
    @State private var vm = FincaViewModel(fincaService: FincaService(), supabase: client)
    var body: some View {
                    Text("Registrar nueva finca")
                    Spacer()
                }
                .foregroundColor(.white)
                .padding()
                .background(midColor1)
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
                        ForEach(vm.fincas) { finca in
                            FincaBox(finca: finca)
                        }
                    }
                    .padding()
                }
            }
            Spacer()
        }
        .task {
            do{
                try await vm.fetchFincas()
            }catch{
                print(vm.errorMessage)
            }
            
        }
    }
}

#Preview {
    DisplayFincasView()
}
