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
    
    
    func fetchLotes() async {
        isLoading = true
        errorMessage = nil
        do {
            let response: PostgrestResponse<[Lote]> = try await client
                .from("Lote")
                .select()
                .order("id_lote", ascending: true)
                .execute()
            lotes = response.value
            if lotes.isEmpty {
                print("Respuesta vacía:", response)
                
            } else {
                print(response.data)
                let raw = try await client.from("Lote").select().execute()
                print(String(data: raw.data, encoding: .utf8)!)
            }
        } catch {
            print(error)
            errorMessage = "Error al cargar los Lotes."
        }
        isLoading = false
    }
}
