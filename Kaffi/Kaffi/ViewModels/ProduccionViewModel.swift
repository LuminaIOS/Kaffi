//
//

import Foundation
import SwiftUI
import Observation
import Supabase

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
    
    private let produccionService: ProduccionService
    private let fincaService: FincaService
    private let supabase: SupabaseClient
    
    init(
        produccionService: ProduccionService,
        fincaService: FincaService,
        supabase: SupabaseClient
    ) {
        self.produccionService = produccionService
        self.fincaService = fincaService
        self.supabase = supabase
    }
    
    func cargarFincas() async {
        isLoading = true
        
        guard let user = supabase.auth.currentUser else {
            mostrarAlerta(titulo: "Error", mensaje: "Sesión expirada. Inicia sesión nuevamente.")
            isLoading = false
            return
        }
        
        do {
            let fincasCargadas = try await fincaService.fetchFincas(forUser: user.id.uuidString)
            self.fincas = fincasCargadas
        } catch {
            mostrarAlerta(
                titulo: "Error",
                mensaje: "No se pudieron cargar las fincas: \(error.localizedDescription)"
            )
        }
        
        isLoading = false
    }
    
    func registrarProduccion() async {
        mostrandoAlerta = false
        tituloAlerta = ""
        mensajeAlerta = ""
        
        guard let user = supabase.auth.currentUser else {
            mostrarAlerta(titulo: "Error", mensaje: "Sesión expirada. Inicia sesión nuevamente.")
            return
        }
        
        guard !manejoSuelo.isEmpty else {
            mostrarAlerta(titulo: "Campo requerido", mensaje: "Agrega al menos una práctica de manejo de suelos.")
            return
        }
        
        guard !controlPlagas.isEmpty else {
            mostrarAlerta(titulo: "Campo requerido", mensaje: "Agrega al menos una práctica de control de plagas.")
            return
        }
        
        guard !riego.trimmingCharacters(in: .whitespaces).isEmpty else {
            mostrarAlerta(titulo: "Campo requerido", mensaje: "Ingresa el tipo de riego utilizado.")
            return
        }
        
        guard !certificacionesSeleccionadas.isEmpty else {
            mostrarAlerta(titulo: "Campo requerido", mensaje: "Selecciona al menos una certificación.")
            return
        }
        
        guard let fincaID = fincaSeleccionadaID else {
            mostrarAlerta(titulo: "Finca requerida", mensaje: "Por favor selecciona una finca.")
            return
        }
        
        isLoading = true
        
        do {
            var certificacionesFinales = certificacionesSeleccionadas
            
            if certificacionesFinales.contains("Otro"), !otraCertificacion.isEmpty {
                if let index = certificacionesFinales.firstIndex(of: "Otro") {
                    certificacionesFinales[index] = otraCertificacion
                }
            } else if certificacionesFinales.contains("Otro") {
                certificacionesFinales.removeAll { $0 == "Otro" }
            }
            
            let nuevasPracticas = PracticasProduccion(
                id_usuario: user.id.uuidString,
                id_finca: fincaID,
                manejo_suelo: manejoSuelo,
                control_plagas: controlPlagas,
                riego: riego,
                certificaciones: certificacionesFinales
            )
            
            try await produccionService.insertPracticasProduccion(nuevasPracticas)
            
            mostrarAlerta(titulo: "¡Éxito!", mensaje: "Prácticas de producción registradas correctamente.")
            resetFormulario()
        } catch {
            mostrarAlerta(titulo: "Error", mensaje: "No se pudieron registrar las prácticas: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func agregarPracticaSuelo() {
        let textoLimpio = nuevaPracticaSuelo.trimmingCharacters(in: .whitespacesAndNewlines)
        if !textoLimpio.isEmpty {
            manejoSuelo.append(textoLimpio)
            nuevaPracticaSuelo = ""
        }
    }
    
    func agregarPracticaPlagas() {
        let textoLimpio = nuevaPracticaPlagas.trimmingCharacters(in: .whitespacesAndNewlines)
        if !textoLimpio.isEmpty {
            controlPlagas.append(textoLimpio)
            nuevaPracticaPlagas = ""
        }
    }
    
    func seleccionarCertificacion(_ certificacion: String) {
        if certificacionesSeleccionadas.contains(certificacion) {
            certificacionesSeleccionadas.removeAll { $0 == certificacion }
            if certificacion == "Otro" { otraCertificacion = "" }
        } else {
            certificacionesSeleccionadas.append(certificacion)
        }
    }
    
    func seleccionarFinca(_ finca: Finca) {
        fincaSeleccionadaID = finca.id_finca
        fincaSeleccionadaNombre = finca.nombre_finca ?? "Sin nombre"
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
