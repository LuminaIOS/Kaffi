//
//  FincaViewModel.swift
//  Kaffi
//
//  Created by Angela Rodriguez on 06/11/25.
//

import Foundation
import SwiftUI
import Observation

@Observable
@MainActor

class FincaViewModel {
    
    var finca = ""
    var productor = ""
    var estado = ""
    var ciudad = ""
    var latitud = 0.0
    var longitud = 0.0
    var hectareas = 0
    var altitud = 0.0
    var suelo = ""
    var descripcion = ""
    
    var isLoading = false
    var mostrandoAlerta = false
    var tituloAlerta = ""
    var mensajeAlerta = ""
    
    private let fincaService: FincaService
    
    init(fincaService: FincaService) {
        self.fincaService = fincaService
    }
    
    func registrarFinca() async {
        
        mostrandoAlerta = false
        tituloAlerta = ""
        mensajeAlerta = ""

        // Validaciones
        if finca.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            productor.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            estado.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            ciudad.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            hectareas <= 0 {
            tituloAlerta = "Campos obligatorios"
            mensajeAlerta = "Por favor llena campos obligatorios."
            mostrandoAlerta = true
            return
        }
        
        isLoading = true
        do {
            
            let usuarioTemporal = "9be34306-96cd-4744-8960-680f6a7ec2c7"
            
            let nuevaFinca = Finca(
                nombre_finca: finca,
                productor: productor,
                estado: estado,
                ciudad: ciudad,
                latitud: latitud,
                longitud: longitud,
                hectareas: hectareas,
                altitud: altitud,
                suelo: suelo,
                descripcion: descripcion,
                id_usuario: usuarioTemporal
            )
            
            try await fincaService.insertFinca(nuevaFinca)
            
            tituloAlerta = "Exito"
            mensajeAlerta = "Finca registrada correctamente."
            mostrandoAlerta = true
            
            resetFormulario()
        } catch {
            tituloAlerta = "Error"
            mensajeAlerta = "No se pudo registrar la finca: \(error.localizedDescription)"
            mostrandoAlerta = true
        }
        isLoading = false
    }
    
    private func resetFormulario() {
        finca = ""
        productor = ""
        estado = ""
        ciudad = ""
        latitud = 0
        longitud = 0
        hectareas = 0
        altitud = 0
        suelo = ""
        descripcion = ""
    }
}
