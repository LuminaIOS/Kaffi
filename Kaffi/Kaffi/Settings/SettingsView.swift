//
//  SettingsView.swift
//  
//
//  Created by Magda on 21/10/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("soundMuted") private var soundMuted = false

    var body: some View {
        VStack{
            
            NavigationView {
                Form {
                    
                    Section(header: Text("Color")) {
                        Toggle("Modo oscuro", isOn: $isDarkMode)
                            .onChange(of: isDarkMode) { _ in
                                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                            }
                    }
                    Section(header: Text("Preferencias")) {
                        Toggle("Notificaciones activadas", isOn: $notificationsEnabled)
                        Toggle("Silenciar", isOn: $soundMuted)
                    }
                    
                    
                }
                
                
            }
        }
        
    }

   
}

#Preview {
    SettingsView()
}
