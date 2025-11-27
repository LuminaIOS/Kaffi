//
//  DisplayFincasView.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 22/10/25.
//
import SwiftUI

struct DisplayFincasView: View {
    @StateObject private var fincaService = FincaService()
    var body: some View {
        VStack {
            HStack {
                NavigationLink(destination: RegisterFincaView()) {
                    Spacer()
                    Image(systemName: "plus.app.fill")
                    Text("Registrar nueva finca")
                    Spacer()
                }
                .foregroundColor(.white)
                .padding()
                .background(midColor1)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)

            if fincaService.isLoading {
                ProgressView("Cargando fincas...")
                    .padding()
            } else if let error = fincaService.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(fincaService.fincas) { finca in
                            FincaBox(finca: finca)
                        }
                    }
                    .padding()
                }
            }
            Spacer()
        }
        .task {
            do {
                try await fincaService.fetchFincas(forUser: "0a3c579d-5237-426f-8bba-182b0813bcea")
            } catch {
                print("Error al cargar fincas: \(error.localizedDescription)")
            }
        }


    }
}

#Preview {
    DisplayFincasView()
}
