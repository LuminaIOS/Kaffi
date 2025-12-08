//
//
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthModel.self) private var vm
    
    var body: some View {
        Group {
            if vm.isLoggedIn {
                TabBarView(vm: vm)
                    .task {
                        if vm.currentUser == nil && !vm.currentId.isEmpty {
                            print("ContentView: Usuario logueado pero sin datos, cargando")
                            await vm.fetchUserData()
                        }
                    }
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
