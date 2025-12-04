//
//  ProduccionService.swift
//

import Foundation
import Supabase

class ProduccionService {
    
    func insertPracticasProduccion(_ practicas: PracticasProduccion) async throws {
        _ = try await client
            .from("Practicas_Produccion")
            .insert([practicas])
            .execute()
    }
    
    func fetchPracticasProduccion(forUser userID: String, fincaID: Int? = nil) async throws -> [PracticasProduccion] {
        var query = client
            .from("Practicas_Produccion")
            .select()
            .eq("id_usuario", value: userID)
        
        if let fincaID = fincaID {
            query = query.eq("id_finca", value: fincaID)
        }
        
        let response: PostgrestResponse<[PracticasProduccion]> = try await query
            .order("idPractica", ascending: false)
            .execute()
        
        return response.value
    }
    
    func getPracticasByFincaID(_ fincaID: Int) async throws -> PracticasProduccion? {
        let response: PostgrestResponse<PracticasProduccion> = try await client
            .from("Practicas_Produccion")
            .select()
            .eq("id_finca", value: fincaID)
            .single()
            .execute()
        
        return response.value
    }
}
