//
//  ContentView.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 21/10/25.
//

import SwiftUI


struct ContentView: View {
    @Environment(AuthModel.self) private var vm
    
    var body: some View {
        Group {
            if vm.isLoggedIn {
                TabBarView()
            } else {
                LoginView(vm: vm)
            }
        }
    }
}


#Preview {
    ContentView()
        .environment(AuthModel())
}
