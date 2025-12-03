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
            NavigationStack {
                DashboardView(vm:vm)
                    .navigationTitle("Dashboard")
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(darkColor2, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Dashboard", systemImage: "house.fill") }
            
            NavigationStack {
                DisplayFincasView()
                    .navigationTitle("Fincas").toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(darkColor2, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Fincas", systemImage: "map.fill") }
            NavigationStack {
                ScrollBarView()
                    .navigationTitle("Registros").toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(darkColor2, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Registros", systemImage: "plus.app.fill") }
            
            NavigationStack {
                DisplayCosechasView()
                    .navigationTitle("Cosechas").toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(darkColor2, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Cosechas", systemImage: "leaf.fill") }
            
            // configurations
            NavigationStack {
                TPerfilView()
                    .navigationTitle("Perfil").toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(darkColor2, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Perfil", systemImage: "person") }
        }
        .tint(midColor1)
    }
}

struct TPerfilView: View {
    @State private var searchText = ""
    var body: some View {
        Text("Perfil")
    }
}
#Preview {
    TabBarView(vm: AuthModel())
}
