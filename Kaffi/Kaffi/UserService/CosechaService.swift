//
//
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
    func fetchCosechas (forUser userID: String) async throws -> [Cosecha] {
        print(userID)
        let response: PostgrestResponse<[Cosecha]> = try await client
            .from("Cosecha")
            .select()
            .eq("id_usuario", value: userID)
            .order("id_cosecha", ascending: true)
            .execute()
        return response.value
    }
    
    func fetchCosechasByFinca (forFinca fincaID: Int) async throws -> [Cosecha] {
        let response: PostgrestResponse<[Cosecha]> = try await client
            .from("Cosecha")
            .select()
            .eq("id_finca", value: fincaID)
            .execute()
        return response.value
    }
}
