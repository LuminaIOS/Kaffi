//
//  ProduccionService.swift
//  Kaffi
//

import Foundation
import Supabase

class ProduccionService {
    
    private let client = SupabaseClient(
        supabaseURL: URL(string: "https://twsylgrqwzncrqkioodg.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR3c3lsZ3Jxd3puY3Jxa2lvb2RnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE1ODg2NDEsImV4cCI6MjA3NzE2NDY0MX0.TzdQQxAbe6DJr7qJFCNATDLiJRbjqMwgyH96oa8ZB9c"
    )
    
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
