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
    
    // Campos del formulario
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
    
    // Imagen
    var selectedImage: UIImage? = nil
    var showingImagePicker = false
    
    // UI state
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
            mensajeAlerta = "Por favor llena los campos obligatorios."
            mostrandoAlerta = true
            return
        }
        
        isLoading = true
        
        do {
            
            var imageUrl: String? = nil
            
            if let selectedImage,
               let data = selectedImage.jpegData(compressionQuality: 0.8) {
                
                let fileName = "\(UUID().uuidString).jpg"
                imageUrl = try await fincaService.uploadImage(data, fileName: fileName)
            }
            
            // Usuario temporal
            let usuarioTemporal = "9be34306-96cd-4744-8960-680f6a7ec2c7"
            
            // Crear nueva finca
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
                id_usuario: usuarioTemporal,
                imagen: imageUrl   // 👈 ESTA ES TU PROPIEDAD REAL
            )
            
            try await fincaService.insertFinca(nuevaFinca)
            
            tituloAlerta = "Éxito"
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
        selectedImage = nil
    }
}
