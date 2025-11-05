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
                TDashboardView()
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
                DisplayLotesView()
                    .navigationTitle("Lotes").toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(darkColor2, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Lotes", systemImage: "mappin") }
            
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

struct TDashboardView: View {
    @State private var searchText = ""
    var body: some View {
        Text("dashboard")
    }
}
struct TFincasView: View {
    @State private var searchText = ""
    var body: some View {
        Text("Fincas")
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
