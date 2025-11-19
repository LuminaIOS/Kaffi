//
//  RecViewModel.swift
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
class RecViewModel {
    
    // Campos del formulario
    
    var id_usuario = ""
    var texto = ""
    
    // UI state
    var isLoading = false
    var mostrandoAlerta = false
    var tituloAlerta = ""
    var mensajeAlerta = ""
    
    private let RecordatorioService: RecordatorioService
    private let supabase: SupabaseClient

    
    init(RecordatorioService: RecordatorioService, supabase: SupabaseClient) {
        self.RecordatorioService = RecordatorioService
        self.supabase = supabase
    }
    
    func registrarRec() async {
        
        mostrandoAlerta = false
        tituloAlerta = ""
        mensajeAlerta = ""

        // Validaciones
        if texto.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            tituloAlerta = "Campos obligatorios"
            mensajeAlerta = "Por favor llena los campos obligatorios."
            mostrandoAlerta = true
            return
        }
        
        isLoading = true
        
        do {
        
            guard let user = supabase.auth.currentUser else {
                tituloAlerta = "Sesión expirada"
                mensajeAlerta = "Debes iniciar sesión nuevamente."
                mostrandoAlerta = true
                isLoading = false
                return
            }
            
            let idUsuario = user.id.uuidString
            
            // Crear nuevo recordatorio
            let nuevaRec = Recordatorio(
                id_usuario: idUsuario,
                texto: texto
            )
            
            try await RecordatorioService.insertRecordatorio(nuevaRec)
            
            tituloAlerta = "Éxito"
            mensajeAlerta = "Recordatorio registrado correctamente."
            mostrandoAlerta = true
            
            resetFormulario()
            
        } catch {
            tituloAlerta = "Error"
            mensajeAlerta = "No se pudo registrar el recordatorio: \(error.localizedDescription)"
            mostrandoAlerta = true
        }
        
        isLoading = false
    }
    
    private func resetFormulario() {
        var id_usuario = ""
        var texto = ""
    }
}
