//
//  FincaService.swift
//  Kaffi
//
//  Created by Angela Rodriguez on 05/11/25.
//

import Foundation
import Supabase
import Combine


class FincaService: ObservableObject {
    @Published var fincas: [Finca] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    
    func uploadImage(_ data: Data, fileName: String) async throws -> String {
        let bucket = "Finca_imagenes"
        let path = "uploads/\(fileName)"

        try await client.storage
            .from(bucket)
            .upload(
                path,
                data: data,
                options: FileOptions(
                    cacheControl: "3600",
                    contentType: "image/png",
                    upsert: false
                )
            )


        let publicUrl = "\(supabase_URL)/storage/v1/object/public/\(bucket)/\(path)"

        return publicUrl
    }


    
    func insertFinca(_ finca: Finca) async throws {
        _ = try await client
            .from("Finca")
            .insert([finca])
            .execute()
    }
    
    func fetchFincas() async {
        isLoading = true
        errorMessage = nil
        do {
            let response: PostgrestResponse<[Finca]> = try await client
                .from("Finca")
                .select()
                .order("nombre_finca", ascending: true)
                .execute()
            fincas = response.value
            if fincas.isEmpty {
                print("Respuesta vacía:", response)
                
            } else {
                print(response.data)
                let raw = try await client.from("Finca").select().execute()
                print(String(data: raw.data, encoding: .utf8)!)

            }
        } catch {
            print(error)
            errorMessage = "Error al cargar las fincas."
        }
        isLoading = false
    }
}

