//
//  KaffiApp.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 21/10/25.
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
