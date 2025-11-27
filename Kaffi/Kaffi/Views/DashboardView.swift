//
//  DashboardView.swift
//
//
//  Created by Magda on 21/10/25.
//
import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel = DashboardViewModel()
    @State private var rvm = RecViewModel(RecordatorioService: RecordatorioService(), supabase: client)
    let supabase = client
    @Bindable var vm: AuthModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                  
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(midColor1)
                            .frame(height: 140)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            if let user = vm.currentUser {
                                Text("Bienvenido \(user.nombreCompleto)")
                                    .font(.title2.weight(.semibold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 5)
                            } else {
                                Text("Cargando usuario...")
                                    .font(.title2.weight(.semibold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 5)
                            }
                            
                            // Search bar
                            HStack(spacing: 5) {
                                Image(systemName: "magnifyingglass")
                                TextField("Buscar lote o finca", text: $viewModel.searchText)
                            }
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 12).fill(.white))
                        }
                        .padding(10)
                    }
                    .padding(.horizontal, 15)
                    
                    
                    // ===== RECORDATORIOS SECTION =====
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recordatorios")
                            .font(.headline)
                        
                        if rvm.isLoading {
                            ProgressView("Cargando fincas...")
                                .padding()
                        } else if let error = rvm.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .padding()
                        } else {
                            
                            // NUEVO RECORDATORIO
                            HStack {
                                Text("Nuevo Recordatorio")
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                NavigationLink(destination: RegisterRecView()) {
                                    Image(systemName: "plus.app.fill")
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 9)
                                }
                            }
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(midColor1))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.darkColor1, lineWidth: 2)
                            )
                            
                            
                            // LISTA DE RECORDATORIOS
                            ForEach(rvm.recordatorios) { rec in
                                RecordatorioBox(recordatorio: rec)
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                }
            }
            .task {
                await rvm.fetchRecordatorios()
            }
        }
    }
}

#Preview {
    DashboardView(vm: AuthModel())
}
