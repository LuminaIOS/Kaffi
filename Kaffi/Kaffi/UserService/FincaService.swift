//
//
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
    
    func fetchFincas(forUser userID: String) async throws -> [Finca] {
        let response: PostgrestResponse<[Finca]> = try await client
            .from("Finca")
            .select()
            .eq("id_usuario", value: userID)
            .order("nombre_finca", ascending: true)
            .execute()
        return response.value
        
    }
    
    func getFincaByID(_ fincaID: Int) async throws -> Finca? {
        let response: PostgrestResponse<Finca> = try await client
            .from("Finca")
            .select()
            .eq("id_finca", value: fincaID)
            .single()
            .execute()
        
        return response.value
    }
}
