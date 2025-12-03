//
//  FincaViewModel.swift
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
class FincaViewModel {
    
    // Campos del formulario
    var finca: String = ""
    var hectareas: Int?
    var altitud: Int?
    var variedadesSeleccionadas: [String] = []
    var portePlanta: String = ""
    var sombra: Int?
    var especieSeleccionadas: [String] = []
    var arboles: Int?
    
    // Imagen
    var selectedImageData: Data? = nil
    
    // UI State
    var isLoading = false
    var mostrandoAlerta = false
    var tituloAlerta = ""
    var mensajeAlerta = ""
    
    // Fincas cargadas
    var fincaByID: Finca?
    var fincas: [Finca] = []
    var errorMessage: String?
    
    private let fincaService: FincaService
    private let supabase: SupabaseClient
    
    init(fincaService: FincaService, supabase: SupabaseClient) {
        self.fincaService = fincaService
        self.supabase = supabase
    }
    

    func registrarFinca() async {
        mostrandoAlerta = false
        tituloAlerta = ""
        mensajeAlerta = ""
        

        guard !finca.trimmingCharacters(in: .whitespaces).isEmpty,
              let hect = hectareas, hect > 0,
              let alt = altitud, alt > 0,
              !variedadesSeleccionadas.isEmpty,
              !portePlanta.isEmpty,
              let sombra = sombra,
              !especieSeleccionadas.isEmpty,
              let arboles = arboles else {
            mostrarAlerta(titulo: "Campos obligatorios", mensaje: "Por favor llena todos los campos obligatorios.")
            return
        }
        
        isLoading = true
        
        do {
           
            let userId = "0a3c579d-5237-426f-8bba-182b0813bcea"
            
            let productorId = 1
            
            var imageUrl: String? = nil
            if let data = selectedImageData {
                let fileName = "\(UUID().uuidString).jpg"
                imageUrl = try await fincaService.uploadImage(data, fileName: fileName)
            }
            

            let nuevaFinca = Finca(
                id_usuario: userId,
                nombre_finca: finca,
                id_productor: productorId,
                hectareas: hect,
                altitud: Double(alt),
                variedades_cult: variedadesSeleccionadas.joined(separator: ", "),
                porte_planta: portePlanta,
                imagen: imageUrl,
                sombra_natural: sombra,
                especies: especieSeleccionadas.joined(separator: ", "),
                arboles_mayores: arboles
            )
            
            try await fincaService.insertFinca(nuevaFinca)
            mostrarAlerta(titulo: "Éxito", mensaje: "Finca registrada correctamente.")
            resetFormulario()
            
        } catch {
            mostrarAlerta(titulo: "Error", mensaje: "No se pudo registrar la finca: \(error.localizedDescription)")
        }
        
        isLoading = false
    }



    private func mostrarAlerta(titulo: String, mensaje: String) {
        self.tituloAlerta = titulo
        self.mensajeAlerta = mensaje
        self.mostrandoAlerta = true
    }
    
    func resetFormulario() {
        finca = ""
        hectareas = nil
        altitud = nil
        variedadesSeleccionadas = []
        portePlanta = ""
        sombra = nil
        especieSeleccionadas = []
        arboles = nil
        selectedImageData = nil
    }
    
    func fetchFincas() async throws{
        isLoading = true
        let user = "22dfed14-863f-454c-985f-16d7bc4afc84"
        do{
            let fetched = try await fincaService.fetchFincas(forUser: user)
            self.fincas = fetched
            
        }catch{
            print("Fetch error: ", error)
            errorMessage = "Error al cargar las cosechas"
        }
        isLoading = false
    }
    
    func getFincaByID(_ fincaID: Int) async throws{
        isLoading = true
        do {
            let finca = try await fincaService.getFincaByID(fincaID)
            self.fincaByID = finca
        } catch {
            print("Fetch error:", error)
            errorMessage = "Error al cargar la finca"
        }
        isLoading = false
    }

}
