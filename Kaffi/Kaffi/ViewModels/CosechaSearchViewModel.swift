//
//  CosechaSearchViewModel.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 04/12/25.
//

import Foundation
import SwiftUI
import Observation
import Supabase

@Observable
@MainActor
class CosechaSearchViewModel {
    // Cosechas cargadas
    var isLoading = false
    var cosechas: [Cosecha] = []
    var fincas: [Finca] = []
    var errorMessage: String?
    
    private let cosechaService: CosechaService
    private let fincaService: FincaService
    private let supabase: SupabaseClient
    
    init(cosechaService: CosechaService, fincaService: FincaService, supabase: SupabaseClient) {
        self.cosechaService = cosechaService
        self.fincaService = fincaService
        self.supabase = supabase
    }
    
    func fetchForSearch() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let user = supabase.auth.currentUser else {
            errorMessage = "Sesión expirada. Inicia sesión nuevamente."
            return
        }
        

        do {
            fincas = try await fincaService.fetchFincas(forUser: user.id.uuidString)
            cosechas = try await cosechaService.fetchCosechas(forUser: user.id.uuidString)
        } catch {
            errorMessage = "Error al cargar las cosechas"
        }
    }
}
