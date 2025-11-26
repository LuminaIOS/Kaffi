//
//  DashboardView.swift
//
//
//  Created by Magda on 21/10/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel = DashboardViewModel()
    @State private var rvm = RecViewModel(RecordatorioService: RecordatorioService(), supabase: client )
    let supabase = client
    @Bindable var vm: AuthModel
    
    var body: some View {
        ScrollView{
            VStack(){
                VStack(alignment: .leading, spacing: 10) {
                    if let user = vm.currentUser {
                        Text("Bienvenido \(user.nombreCompleto)")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(5)
                    } else {
                        Text("Cargando usuario...")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(5)
                    }
                    HStack (spacing: 5) {
                        Image(systemName: "magnifyingglass")
                        TextField("Buscar lote o finca", text: $viewModel.searchText)
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 12).fill(.white))
                }
                .padding(10)
                .frame(height: 140)
                .background(midColor1)
                .cornerRadius(10)
                .padding(15)
                
                
            }
            VStack(alignment: .leading){
                Text("Recordatorios")
                    .bold()
                
                if rvm.isLoading {
                    ProgressView("Cargando fincas...")
                        .padding()
                } else if let error = rvm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    VStack(){
                        //NUEVO RECORDATORIO
                        HStack(){
                            VStack(alignment: .leading) {
                                Text("Nuevo Recordatorio")
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            NavigationLink(destination: RegisterRecView()) {
                                Image(systemName: "plus.app.fill")
                                    .foregroundColor(.white)
                                    .padding(.horizontal,9)
                            }
                                
                        }
                        .padding(8)
                        .frame(width: 320, alignment: .leading)
                        .background(Color(midColor1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.darkColor1, lineWidth: 2)
                        )
                        
                        //RECORDATORIOS DE DB
                        ForEach(rvm.recordatorios) { rec in
                            ZStack {
                                RecordatorioBox(recordatorio: rec)
                            }
                        }
                    }
                }
            }
            .task {
                await rvm.fetchRecordatorios()
            }
            Spacer()
        }
    }
}
#Preview {
    DashboardView(vm: AuthModel())
}
