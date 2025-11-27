//
//  CosechaViewModel.swift
//  Trial
//
//  Created by Angela Rodriguez on 26/11/25.
//

import Foundation
import SwiftUI
import Observation
import Supabase

@Observable
@MainActor
class CosechaViewModel {
    
    // Campos del formulario
    var volumen: String = ""
    var inicioCosecha: String = ""
    var finCosecha: String = ""
    
    var procesamiento: String = ""
    var fermentacion: Int?            
    var secado: String = ""
    var subproductos: String = ""
    var tratamientoAgua: String = ""
    
    // Emisiones
    var emisiones: Float?
    var capturaArboles: Float?
    var emisionesNetas: Float?
    
    // Agua
    var aguaBeneficio: Float?
    var aguaRiego: Float?
    var huellaTotal: String = ""
    
    // Calidad
    var catacion: Float?
    var sensorial: String = ""
    
    // Otros
    var empaque: String = ""
    var nutricional: String = ""
    
    // Imagen
    var selectedImageData: Data? = nil
    
    // UI State
    var isLoading = false
    var mostrandoAlerta = false
    var tituloAlerta = ""
    var mensajeAlerta = ""
    
    // Cosechas cargadas
    var cosechas: [Cosecha] = []
    var errorMessage: String?
    
    private let cosechaService: CosechaService
    private let supabase: SupabaseClient
    
    init(cosechaService: CosechaService, supabase: SupabaseClient) {
        self.cosechaService = cosechaService
        self.supabase = supabase
    }
    

    func registrarCosecha() async {
        
        mostrandoAlerta = false
        tituloAlerta = ""
        mensajeAlerta = ""
        

        guard !volumen.isEmpty,
              !procesamiento.isEmpty,
              fermentacion != nil,
              !secado.isEmpty,
              !subproductos.isEmpty,
              !tratamientoAgua.isEmpty else {
            mostrarAlerta(titulo: "Campos obligatorios",
                          mensaje: "Por favor completa los campos requeridos.")
            return
        }

        
        isLoading = true
        
        do {
            let userId = "0a3c579d-5237-426f-8bba-182b0813bcea"
            
            // Para futuro: id de finca o coop
            let fincaId: Int? = nil
            let coopId: Int? = nil
            
            // Subir imagen si existe
            var imageUrl: String? = nil
            if let data = selectedImageData {
                let fileName = "cosecha_\(UUID().uuidString).jpg"
                imageUrl = try await cosechaService.uploadImage(data, fileName: fileName)
            }
            
            // Crear objeto Cosecha
            let nuevaCosecha = Cosecha(
                volumen: volumen,
                inicio_cosecha: inicioCosecha,
                fin_cosecha: finCosecha,
                procesamiento: procesamiento,
                fermentacion: fermentacion,   
                secado: secado,
                subproductos: subproductos,
                tratamiento_agua: tratamientoAgua,
                emisiones_carbono: emisiones,
                emisiones_captura: capturaArboles,
                emisiones_neto: emisionesNetas,
                agua_beneficio: aguaBeneficio,
                agua_riego: aguaRiego,
                agua_huella: huellaTotal,
                id_usuario: userId,
                id_finca: fincaId,
                id_coop: coopId,
                puntaje_catacion: catacion,
                perfil_sensorial: sensorial,
                empaque: empaque,
                contenido_nutricional: nutricional,
                imagen_cosecha: imageUrl
            )
            
            try await cosechaService.insertCosecha(nuevaCosecha)
            mostrarAlerta(titulo: "Éxito", mensaje: "Cosecha registrada correctamente.")
            resetFormulario()
            
        } catch {
            mostrarAlerta(
                titulo: "Error",
                mensaje: "No se pudo registrar la cosecha: \(error.localizedDescription)"
            )
        }
        
        isLoading = false
    }
    

    private func mostrarAlerta(titulo: String, mensaje: String) {
        self.tituloAlerta = titulo
        self.mensajeAlerta = mensaje
        self.mostrandoAlerta = true
    }
    

    func resetFormulario() {
        volumen = ""
        inicioCosecha = ""
        finCosecha = ""
        
        procesamiento = ""
        fermentacion = nil        
        secado = ""
        subproductos = ""
        tratamientoAgua = ""
        
        emisiones = nil
        capturaArboles = nil
        emisionesNetas = nil
        
        aguaBeneficio = nil
        aguaRiego = nil
        huellaTotal = ""
        
        catacion = nil
        sensorial = ""
        
        empaque = ""
        nutricional = ""
        
        selectedImageData = nil
    }
}



