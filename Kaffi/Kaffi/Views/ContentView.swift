//
//  ContentView.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 21/10/25.
//

import SwiftUI


struct ContentView: View {
    @State var vm = AuthModel()
    
    var body: some View {
        Group {
            if vm.isLoggedIn {
                TabBarView(vm: vm)
            } else {
                LoginView(vm: vm)
            }
        }
    }
}


#Preview {
    ContentView()
}
