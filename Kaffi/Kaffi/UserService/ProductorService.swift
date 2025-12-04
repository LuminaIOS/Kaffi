//
//  ProductorService.swift
//  Trial
//
//  Created by Angela Rodriguez on 26/11/25.
//

import Foundation
import Supabase
import Combine

class ProductorService: ObservableObject {
    func uploadImage(_ data: Data, fileName: String) async throws -> String {
        let bucket = "Productor_imagenes"
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
    
    func uploadVideo(_ data: Data, fileName: String) async throws -> String {
        let bucket = "Productor_videos"
        let path = "uploads/\(fileName)"

        try await client.storage
            .from(bucket)
            .upload(
                path,
                data: data,
                options: FileOptions(
                    cacheControl: "3600",
                    contentType: "video/mp4",
                    upsert: false
                )
            )

        let publicUrl = "\(supabase_URL)/storage/v1/object/public/\(bucket)/\(path)"
        return publicUrl
    }


    func insertProductor(_ productor: Productor) async throws {
        _ = try await client
            .from("Productor")
            .insert([productor])
            .execute()
    }
    
    func getProByID(_ proID: Int) async throws -> Productor? {
        let response: PostgrestResponse<[Productor]> = try await client
            .from("Productor")
            .select("*")
            .eq("idProductor", value: proID)
            .execute()
        return response.value.first
        
    }
    
    func getProductoresByUser(_ userId: String) async throws -> [Productor] {
        let response: PostgrestResponse<[Productor]> = try await client
            .from("Productor")
            .select("*")
            .eq("idTecnico", value: userId) 
            .execute()
        
        return response.value
    }

    
    
}

