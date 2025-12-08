//
//
//

import SwiftUI

@main
struct KaffiApp: App {
    @State private var authModel = AuthModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authModel)
        }
    }
}
