//
//  ScrollBarView.swift
//  Trial
//
//  Created by Angela Rodriguez on 22/11/25.
//

import SwiftUI

struct ScrollBarView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab = "Productor"
    
    let tabs = [
        "Productor",
        "Finca",
        "Técnico y Control Interno",
        "Prácticas de Producción",
        "Cosecha y Producto Final" 
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(tabs, id: \.self) { tab in
                        Text(tab)
                            .font(.system(size: 16, weight: .medium))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(
                                selectedTab == tab ?
                                    Color.midColor1.opacity(0.25) :
                                    Color.gray.opacity(0.15)
                            )
                            .foregroundColor(selectedTab == tab ? .darkColor1 : .gray)
                            .cornerRadius(20)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedTab = tab
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 15)
            
            contentView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.easeInOut, value: selectedTab)
            
            Spacer()
        }
        .navigationTitle("Registros")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
            }
    
    
    
    @ViewBuilder
    func contentView() -> some View {
        switch selectedTab {
        case "Productor":
           RegisterProductorView()
        case "Finca":
            RegisterFincaView()
        case "Técnico y Control Interno":
            RegisterTecnicoView()
        case "Prácticas de Producción":
            RegisterProduccionView()
        case "Cosecha y Producto Final":
            RegisterCosechaView()


        default:
            Text("Contenido de: \(selectedTab)")
                .font(.title3)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    NavigationStack {
        ScrollBarView()
    }
}


