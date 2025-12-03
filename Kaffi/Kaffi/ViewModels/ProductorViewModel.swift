//
//  ProductorViewModel.swift
//  Trial
//
//  Created by Angela Rodriguez on 26/11/25.
//

import Foundation
import SwiftUI
import Observation
import Supabase
import PhotosUI

@Observable
@MainActor
class ProductorViewModel {
    
    // Campos del formulario
    var nombre: String = ""
    var edad: Int?
    var genero: String = ""
    var generacion: String = ""
    var ubicacion: String = ""
    var comunidad: String = ""
    var latitud: Double?
    var longitud: Double?
    var testimonio: String = ""
    
    // Multimedia
    var selectedImage: PhotosPickerItem?
    var selectedImageData: Data?

    var selectedVideo: PhotosPickerItem?
    var selectedVideoData: Data?
    
    // Estado UI
    var isLoading = false
    var mostrandoAlerta = false
    var tituloAlerta = ""
    var mensajeAlerta = ""
    
    var errorMessage: String?
    var productorByID: Productor?
    var productores: [Productor]=[]
    
    private let productorService: ProductorService
    private let supabase: SupabaseClient
    
    init(productorService: ProductorService, supabase: SupabaseClient) {
        self.productorService = productorService
        self.supabase = supabase
    }
    

    func registrarProductor() async {
        
        guard validarCampos() else { return }
        isLoading = true
        
        do {

            let idTecnico = "0a3c579d-5237-426f-8bba-182b0813bcea"
            let idFinca = 41
            
            // Subir imagen
            var fotoURL: String? = nil
            if let imgData = selectedImageData {
                let fileName = "IMG-\(UUID().uuidString).jpg"
                fotoURL = try await productorService.uploadImage(imgData, fileName: fileName)
            }
            
            // Subir video
            var videoURL: String? = nil
            if let vidData = selectedVideoData {
                let fileName = "VID-\(UUID().uuidString).mp4"
                videoURL = try await productorService.uploadVideo(vidData, fileName: fileName)
            }
            
            // Construcción EXACTA según el MODEL
            let nuevo = Productor(
                Nombre: nombre,
                Edad: edad,
                Genero: genero,
                Generacion: generacion,
                Ubicacion: ubicacion,
                Latitud: latitud,
                Longitud: longitud,
                Comunidad: comunidad,
                Foto: fotoURL,
                Video: videoURL,
                Testimonio: testimonio,
                idFinca: idFinca,
                idTecnico: idTecnico   
            )
            
            try await productorService.insertProductor(nuevo)
            
            mostrarAlerta("Éxito", "Productor registrado correctamente.")
            resetFormulario()
            
        } catch {
            mostrarAlerta("Error", "No se pudo registrar el productor: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    
    // MARK: Validación
    private func validarCampos() -> Bool {
        if nombre.isEmpty || edad == nil || genero.isEmpty || generacion.isEmpty ||
            ubicacion.isEmpty || comunidad.isEmpty || latitud == nil ||
            longitud == nil || testimonio.isEmpty {
            
            mostrarAlerta("Campos incompletos", "Debes llenar todos los campos obligatorios.")
            return false
        }
        return true
    }
    
    
    // MARK: Alerta
    private func mostrarAlerta(_ titulo: String, _ mensaje: String) {
        tituloAlerta = titulo
        mensajeAlerta = mensaje
        mostrandoAlerta = true
    }
    
    
    // MARK: Reset
    func resetFormulario() {
        nombre = ""
        edad = nil
        genero = ""
        generacion = ""
        ubicacion = ""
        comunidad = ""
        latitud = nil
        longitud = nil
        testimonio = ""
        selectedImageData = nil
        selectedVideoData = nil
    }
    
    func fetchProductores() async throws{
        isLoading = true
        do{
            let fetched = try await productorService.fetchProductores()
            self.productores = fetched
            
        }catch{
            print("Fetch error: ", error)
            errorMessage = "Error al cargar los productores"
        }
        isLoading = false
    }
    
    func getProByID(_ proID: Int) async throws{
        isLoading = true
        do {
            let productor = try await productorService.getProByID(proID)
            print("API returned:", productor as Any)
            self.productorByID = productor
        } catch {
            print("Fetch error:", error)
            errorMessage = "Error al cargar el productor"
        }
        isLoading = false
    }
}

