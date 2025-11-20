//
//  LoteViewModel.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 18/11/25.
//

import Foundation
import SwiftUI
import Observation
import Supabase

@Observable
@MainActor
class LoteViewModel {
    // UI state
    var isLoading = false
    var mostrandoAlerta = false
    var tituloAlerta = ""
    var mensajeAlerta = ""
    var lotes: [Lote] = []
    var errorMessage: String?
    
    private let LoteService: LoteService
    private let supabase: SupabaseClient

    
    init(LoteService: LoteService, supabase: SupabaseClient) {
        self.LoteService = LoteService
        self.supabase = supabase
    }
    
    func fetchLotes() async {
        //let user = "22dfed14-863f-454c-985f-16d7bc4afc84"
        //do {
        //  let fetched = try await LoteService.fetchLotes(forUser: user)
        //  self.lotes = fetched
        
        
        guard let user = supabase.auth.currentUser else {
            errorMessage = "Sesión expirada. Inicia sesión nuevamente."
            isLoading = false
            return
        }
        do {
            let fetched = try await LoteService.fetchLotes(forUser: user.id.uuidString)
            self.lotes = fetched
            
        } catch {
            print("Fetch error:", error)
            errorMessage = "Error al cargar los lotes."
        }
        isLoading = false
    }
}
