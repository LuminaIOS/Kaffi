//
//  LoteDetailService.swift
//  Kaffi
//

import Foundation
import Supabase

class LoteDetailService {
    func fetchLoteDetail(id_lote: Int) async throws -> LoteDetail {
        let loteResponse: [Lote] = try await client
            .from("Lote")
            .select()
            .eq("id_lote", value: id_lote)
            .execute()
            .value
        
        guard let lote = loteResponse.first else {
            throw NSError(domain: "Lote no encontrado", code: 404)
        }
        
        let fincaResponse: [Finca] = try await client
            .from("Finca")
            .select()
            .eq("id_finca", value: lote.id_finca)
            .execute()
            .value
        
        let finca = fincaResponse.first
        
        var practicas: [String] = []
        
        do {
            let practicasResponse: [UnionPyF] = try await client
                .from("unionPyF") 
                .select("""
                    Practicas (
                        NombreP
                    )
                """)
                .eq("idFinca", value: lote.id_finca)
                .execute()
                .value
            
            practicas = practicasResponse.compactMap { $0.Practicas?.NombreP }
            
            // Si no encontramos prácticas, mostramos un log
            if practicas.isEmpty {
                print("No se encontraron prácticas para la finca ID: \(lote.id_finca)")
                
                // Verificamos si hay datos en la tabla unionPyF para debug
                let debugResponse = try await client
                    .from("unionPyF")
                    .select()
                    .eq("idFinca", value: lote.id_finca)
                    .execute()
                
                print("Debug unionPyF: \(String(data: debugResponse.data, encoding: .utf8) ?? "sin datos")")
            }
            
        } catch {
            print("Error al cargar prácticas: \(error)")
            // Si hay error, simplemente dejamos el array vacío
            practicas = []
        }
        
        return LoteDetail(
            lote: lote,
            finca: finca,
            practicasSostenibles: practicas
        )
    }
}

// Modelo para la tabla unionPyF
struct UnionPyF: Codable {
    let idUnion: Int?
    let idFinca: Int?
    let idPractica: Int?
    let Practicas: Practica?
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
