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
    

    var nombre: String = ""
    var edad: Int?
    var genero: String = ""
    var generacion: String = ""
    var ubicacion: String = ""
    var comunidad: String = ""
    var latitud: Double?
    var longitud: Double?
    var testimonio: String = ""
    

    var selectedImage: PhotosPickerItem?
    var selectedImageData: Data?

    var selectedVideo: PhotosPickerItem?
    var selectedVideoData: Data?
    

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

 
        mostrandoAlerta = false
        tituloAlerta = ""
        mensajeAlerta = ""


        guard
            !nombre.trimmingCharacters(in: .whitespaces).isEmpty,
            let edad = edad, edad > 0,
            !genero.trimmingCharacters(in: .whitespaces).isEmpty,
            !generacion.trimmingCharacters(in: .whitespaces).isEmpty,
            !ubicacion.trimmingCharacters(in: .whitespaces).isEmpty,
            !comunidad.trimmingCharacters(in: .whitespaces).isEmpty,
            let latitud = latitud,
            let longitud = longitud,
            !testimonio.trimmingCharacters(in: .whitespaces).isEmpty else {
            mostrarAlerta("Campos obligatorios", "Por favor llena todos los campos obligatorios.")
                return
            }


        

        isLoading = true

        do {
            let idTecnico = supabase.auth.currentUser!.id.uuidString

   
            var fotoURL: String? = nil
            if let imgData = selectedImageData {
                let fileName = "IMG-\(UUID().uuidString).jpg"
                fotoURL = try await productorService.uploadImage(imgData, fileName: fileName)
            }

     
            var videoURL: String? = nil
            if let vidData = selectedVideoData {
                let fileName = "VID-\(UUID().uuidString).mp4"
                videoURL = try await productorService.uploadVideo(vidData, fileName: fileName)
            }

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
                idFinca: nil,
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

    

    
    
    private func mostrarAlerta(_ titulo: String, _ mensaje: String) {
        tituloAlerta = titulo
        mensajeAlerta = mensaje
        mostrandoAlerta = true
    }
    
    
  
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
    
    func getProByID(_ proID: Int) async throws{
        isLoading = true
        do {
            let productor = try await productorService.getProByID(proID)
            self.productorByID = productor
        } catch {
            errorMessage = "Error al cargar el productor"
        }
        isLoading = false
    }
    
    func fetchProductores() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let userId = supabase.auth.currentUser!.id.uuidString
            self.productores = try await productorService.getProductoresByUser(userId)
        } catch {
            print("Error cargando productores:", error)
            errorMessage = "No se pudieron cargar los productores"
        }
    }
}

