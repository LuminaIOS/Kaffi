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
            
            if practicas.isEmpty {
                print("No se encontraron prácticas para la finca ID: \(lote.id_finca)")
                
                let debugResponse = try await client
                    .from("unionPyF")
                    .select()
                    .eq("idFinca", value: lote.id_finca)
                    .execute()
                
                print("Debug unionPyF: \(String(data: debugResponse.data, encoding: .utf8) ?? "sin datos")")
            }
            
        } catch {
            print("Error al cargar prácticas: \(error)")
            practicas = []
        }
        
        return LoteDetail(
            lote: lote,
            finca: finca,
            practicasSostenibles: practicas
        )
    }
}

struct UnionPyF: Codable {
    let idUnion: Int?
    let idFinca: Int?
    let idPractica: Int?
    let Practicas: Practica?
}

struct Practica: Codable {
    let NombreP: String
}

struct LoteDetail {
    let lote: Lote
    let finca: Finca?
    let practicasSostenibles: [String]
}
