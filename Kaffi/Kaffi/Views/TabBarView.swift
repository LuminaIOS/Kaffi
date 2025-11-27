//
//  NavBar.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 21/10/25.
//
//

import SwiftUI

struct TabBarView: View {
    @State private var searchText = ""
    @Bindable var vm: AuthModel
    
    var body: some View {
        TabView {
            
            // DASHBOARD
            NavigationStack {
                DashboardView(vm: vm)
                    .navigationTitle("Dashboard")
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(darkColor2, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Dashboard", systemImage: "house.fill") }
            
            
            // FINCAS
            NavigationStack {
                DisplayFincasView()
                    .navigationTitle("Fincas")
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(darkColor2, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Fincas", systemImage: "map.fill") }
            
            
            // LOTES
            NavigationStack {
                DisplayLotesView()
                    .navigationTitle("Lotes")
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(darkColor2, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Lotes", systemImage: "mappin") }
            
            
            // PERFIL
            NavigationStack {
                ProfileView()
                    .navigationTitle("Perfil")
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(darkColor2, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Perfil", systemImage: "person") }
        }
        .environment(vm)   
        .tint(midColor1)
    }
}

#Preview {
    TabBarView(vm: AuthModel())
}
