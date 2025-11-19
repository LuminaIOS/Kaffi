//
//  LoteService.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 08/11/25.
//


import Foundation
import Supabase
import Combine


class LoteService: ObservableObject {
    @Published var lotes: [Lote] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchLotes(forUser userID: String) async throws -> [Lote] {
        let response: PostgrestResponse<[Lote]> = try await client
            .from("Lote")
            .select()
            .eq("id_usuario", value: userID)
            .order("nombre", ascending: true)
            .execute()
        return response.value
    }
}
