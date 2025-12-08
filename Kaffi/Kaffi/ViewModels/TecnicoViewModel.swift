//
//
//

import Foundation
import SwiftUI
import Observation
import Supabase

@Observable
@MainActor
class TecnicoViewModel {
    
    var tecnico: String = ""
    var cargo: String = ""
    var visita: String = ""
    var resultado: String = ""
    var fechaLevantamiento: Date = Date()
    
    var isLoading = false
    var mostrandoAlerta = false
    var tituloAlerta = ""
    var mensajeAlerta = ""
    
    var tecnicos: [Tecnico] = []
    var errorMessage: String?
    
    private let tecnicoService: TecnicoService
    private let supabase: SupabaseClient
    
    init(tecnicoService: TecnicoService, supabase: SupabaseClient) {
        self.tecnicoService = tecnicoService
        self.supabase = supabase
    }
    
    func registrarTecnico(fincaId: Int?) async {
        mostrandoAlerta = false
        tituloAlerta = ""
        mensajeAlerta = ""

        guard !tecnico.trimmingCharacters(in: .whitespaces).isEmpty,
              !cargo.trimmingCharacters(in: .whitespaces).isEmpty,
              !visita.trimmingCharacters(in: .whitespaces).isEmpty,
              !resultado.trimmingCharacters(in: .whitespaces).isEmpty,
              let fincaId = fincaId else {
            mostrarAlerta(titulo: "Campos obligatorios", mensaje: "Por favor llena todos los campos obligatorios.")
            return
        }

        isLoading = true

        do {
            let userId = supabase.auth.currentUser!.id.uuidString

            let nuevoTecnico = Tecnico(
                id_finca: fincaId,
                id_usuario: userId,
                nombre_respo: tecnico,
                cargo: cargo,
                tipo_visita: visita,
                fecha_reg: fechaLevantamiento,
                resultado: resultado
            )

            try await tecnicoService.insertTecnico(nuevoTecnico)

            mostrarAlerta(titulo: "Éxito", mensaje: "Registro de técnico completado correctamente.")
            resetFormulario()

        } catch {
            mostrarAlerta(titulo: "Error", mensaje: "No se pudo registrar el técnico: \(error.localizedDescription)")
        }

        isLoading = false
    }

    
    private func mostrarAlerta(titulo: String, mensaje: String) {
        self.tituloAlerta = titulo
        self.mensajeAlerta = mensaje
        self.mostrandoAlerta = true
    }
    
    func resetFormulario() {
        tecnico = ""
        cargo = ""
        visita = ""
        resultado = ""
        fechaLevantamiento = Date()
    }
}

