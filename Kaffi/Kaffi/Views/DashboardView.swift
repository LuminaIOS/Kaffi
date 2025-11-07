//
//  DashboardView.swift
//
//
//  Created by Magda on 21/10/25.
//

import SwiftUI



struct DashboardView: View {
    @StateObject var viewModel = DashboardViewModel()
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(darkColor1)
                        .frame(height: 140)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("Bienvenida \(viewModel.nombre)" )
                            .font(.title2
                                .weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(5)
                        
                        HStack (spacing: 5) {
                            Image(systemName: "magnifyingglass")
                            TextField("Buscar lote o finca", text: $viewModel.searchText)
                            
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 12).fill(.white))
                        
                        
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
            
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Finca de Santa Cruz").font(.headline).foregroundStyle(.white)
                    Text("Recuerda visitar la Finca de Santa Cruz").font(.subheadline).foregroundStyle(.white.opacity(0.9))
                }
                Spacer()
            }
            .padding(16)
            .background(RoundedRectangle(cornerRadius: 16).fill(midColor1))
            .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
            .padding(.horizontal, 16)
            
            
        }
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "chart.bar.fill").foregroundStyle(darkColor2)
                Text("Estadística 1").font(.headline)
                Spacer()
            }
            Image("testGrafica")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, minHeight: 120, maxHeight: 160)
                .clipped()
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16)
            .fill(Color("AppBackground", bundle: .main)))
        .shadow(color: .black.opacity(0.06), radius: 10, y: 6)
        .padding(.horizontal, 16)
        
        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
        
        
        let columns: [GridItem] = [
            .init(.flexible(), spacing: 20),
            .init(.flexible(), spacing: 20)
        ]

        LazyVGrid(columns: columns, spacing: 20) {
            Button { viewModel.TapFincas() } label: {
                TarjetaView(
                    title: "Tus Fincas",
                    subtitle: "\(viewModel.numFincas) registradas",
                    imageName: "finca"
                )
            }
            .buttonStyle(.plain)

            Button { viewModel.TapLotes() } label: {
                TarjetaView(
                    title: "Tus Lotes",
                    subtitle: "\(viewModel.numLotes) registrados",
                    imageName: "lote"
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)

        
        
    }
       
}
#Preview {
    DashboardView()
}
