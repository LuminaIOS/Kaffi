//
//  ProduccionViewModel.swift
//

import Foundation
import SwiftUI
import Observation

@Observable
@MainActor
class ProduccionViewModel {
    
    var manejoSuelo: [String] = []
    var nuevaPracticaSuelo: String = ""
    var controlPlagas: [String] = []
    var nuevaPracticaPlagas: String = ""
    var riego: String = ""
    
    var certificacionesSeleccionadas: [String] = []
    var otraCertificacion: String = ""
    
    var mostrarListaCertificaciones = false
    
    var fincas: [Finca] = []
    var fincaSeleccionadaID: Int?
    var fincaSeleccionadaNombre: String = "Seleccionar finca"
    
    var isLoading = false
    var mostrandoAlerta = false
    var tituloAlerta = ""
    var mensajeAlerta = ""
    
    let certificacionesDisponibles: [String] = [
        "USDA Organic (NOP) – Certimex, vigente 2025",
        "Certificado LPO – México Orgánico",
        "Fairtrade International – FLO ID 57893",
        "En transición a Carbono Neutral (ISO 14064)",
        "Otro"
    ]
    
    private let produccionService = ProduccionService()
    private let fincaService = FincaService()
    
    func cargarFincas() async {
        isLoading = true
        
        let userID = "22dfed14-863f-454c-985f-16d7bc4afc84"
        
        do {
            let fincasCargadas = try await fincaService.fetchFincas(forUser: userID)
            self.fincas = fincasCargadas
        } catch {
            mostrarAlerta(titulo: "Error", mensaje: "No se pudieron cargar las fincas: \(error.localizedDescription)")
        }
        isLoading = false
    }
    
    func registrarProduccion() async {
        mostrandoAlerta = false
        tituloAlerta = ""
        mensajeAlerta = ""
        
        guard !manejoSuelo.isEmpty,
              !controlPlagas.isEmpty,
              !riego.trimmingCharacters(in: .whitespaces).isEmpty,
              !certificacionesSeleccionadas.isEmpty else {
            mostrarAlerta(titulo: "Campos obligatorios",
                         mensaje: "Por favor completa todos los campos obligatorios.")
            return
        }
        
        guard let fincaID = fincaSeleccionadaID else {
            mostrarAlerta(titulo: "Finca requerida",
                         mensaje: "Por favor selecciona una finca para asociar las prácticas.")
            return
        }
        
        isLoading = true
        
        do {
            let userID = "22dfed14-863f-454c-985f-16d7bc4afc84"
            
            var certificacionesFinales = certificacionesSeleccionadas
            if certificacionesFinales.contains("Otro"), !otraCertificacion.isEmpty {
                if let index = certificacionesFinales.firstIndex(of: "Otro") {
                    certificacionesFinales[index] = otraCertificacion
                }
            } else if certificacionesFinales.contains("Otro") {
                certificacionesFinales.removeAll { $0 == "Otro" }
            }
            
            let nuevasPracticas = PracticasProduccion(
                id_usuario: userID,
                id_finca: fincaID,
                manejo_suelo: manejoSuelo,
                control_plagas: controlPlagas,
                riego: riego,
                certificaciones: certificacionesFinales
            )
            
            try await produccionService.insertPracticasProduccion(nuevasPracticas)
            
            mostrarAlerta(titulo: "Éxito", mensaje: "Prácticas de producción registradas correctamente.")
            resetFormulario()
            
        } catch {
            mostrarAlerta(titulo: "Error",
                         mensaje: "No se pudieron registrar las prácticas: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func agregarPracticaSuelo() {
        if !nuevaPracticaSuelo.trimmingCharacters(in: .whitespaces).isEmpty {
            manejoSuelo.append(nuevaPracticaSuelo.trimmingCharacters(in: .whitespaces))
            nuevaPracticaSuelo = ""
        }
    }
    
    func agregarPracticaPlagas() {
        if !nuevaPracticaPlagas.trimmingCharacters(in: .whitespaces).isEmpty {
            controlPlagas.append(nuevaPracticaPlagas.trimmingCharacters(in: .whitespaces))
            nuevaPracticaPlagas = ""
        }
    }
    
    func seleccionarCertificacion(_ certificacion: String) {
        if certificacionesSeleccionadas.contains(certificacion) {
            certificacionesSeleccionadas.removeAll { $0 == certificacion }
            if certificacion == "Otro" {
                otraCertificacion = ""
            }
        } else {
            certificacionesSeleccionadas.append(certificacion)
        }
    }
    
    func seleccionarFinca(_ finca: Finca) {
        fincaSeleccionadaID = finca.id_finca
        fincaSeleccionadaNombre = finca.nombre_finca
    }
    
    private func mostrarAlerta(titulo: String, mensaje: String) {
        self.tituloAlerta = titulo
        self.mensajeAlerta = mensaje
        self.mostrandoAlerta = true
    }
    
    func resetFormulario() {
        manejoSuelo = []
        nuevaPracticaSuelo = ""
        controlPlagas = []
        nuevaPracticaPlagas = ""
        riego = ""
        certificacionesSeleccionadas = []
        otraCertificacion = ""
        mostrarListaCertificaciones = false
        fincaSeleccionadaID = nil
        fincaSeleccionadaNombre = "Seleccionar finca"
    }
}
