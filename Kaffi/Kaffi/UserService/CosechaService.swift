//
//  CosechaService.swift
//  Trial
//
//  Created by Angela Rodriguez on 26/11/25.
//

import Foundation
import Supabase
import Combine


class CosechaService: ObservableObject {
    @Published var cosecha: [Cosecha] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    
    func uploadImage(_ data: Data, fileName: String) async throws -> String {
        let bucket = "Cosecha_imagenes"
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
    
    func insertCosecha(_ cosecha: Cosecha) async throws {
        _ = try await client
            .from("Cosecha")
            .insert([cosecha])
            .execute()
    }
}
