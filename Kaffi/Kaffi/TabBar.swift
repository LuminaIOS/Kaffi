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

    
    
    var body: some View {
        TabView {
            NavigationStack {
                TDashboardView()
                    .navigationTitle("Dashboard")
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(.darkColor2, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            
            .tabItem { Label("Dashboard", systemImage: "house.fill") }
            
            
            NavigationStack {
                TFincasView()
                    .navigationTitle("Fincas").toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(Color("darkColor2"), for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Fincas", systemImage: "map.fill") }
            
            NavigationStack {
                TLotesView()
                    .navigationTitle("Lotes").toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(Color("darkColor2"), for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Lotes", systemImage: "mappin") }
            
            NavigationStack {
                TAjustesView()
                    .navigationTitle("Ajustes").toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(Color("darkColor2"), for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Ajustes", systemImage: "gearshape.fill") }
            
            // configurations
        }
        .tint(Color("midColor1"))
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
struct TLotesView: View {
    @State private var searchText = ""
    var body: some View {
        Text("Lotes")
    }
}


struct TAjustesView: View {
    @State private var searchText = ""
    var body: some View {
        Text("Ajustes")
    }
}

  


#Preview {
    TabBarView()
}
