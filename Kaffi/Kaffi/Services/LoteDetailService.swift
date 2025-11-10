//
//  LoteDetailService.swift
//  Kaffi
//

import Foundation
import Supabase

class LoteDetailService {
    func fetchLoteDetail(id_lote: Int) async throws -> LoteDetail {
        // Obtener datos básicos del lote
        let loteResponse: [Lote] = try await client
            .from("Lote")
            .select()
            .eq("id_lote", value: id_lote)
            .execute()
            .value
        
        guard let lote = loteResponse.first else {
            throw NSError(domain: "Lote no encontrado", code: 404)
        }
        
        // Obtener datos de la finca relacionada
        let fincaResponse: [Finca] = try await client
            .from("Finca")
            .select()
            .eq("id_finca", value: lote.id_finca)
            .execute()
            .value
        
        let finca = fincaResponse.first
        
        // Obtener prácticas sostenibles de la finca
        let practicasResponse: [Practica] = try await client
            .from("unionPyF")
            .select("""
                Practicas (
                    NombreP
                )
            """)
            .eq("idFinca", value: lote.id_finca)
            .execute()
            .value
        
        let practicas = practicasResponse.map { $0.NombreP }
        
        return LoteDetail(
            lote: lote,
            finca: finca,
            practicasSostenibles: practicas
        )
    }
}

// Modelo para prácticas
struct Practica: Codable {
    let NombreP: String
}

// Modelo para los datos detallados del lote
struct LoteDetail {
    let lote: Lote
    let finca: Finca?
    let practicasSostenibles: [String]
}
