//
//
//
import Foundation
import Supabase
import Combine


class RecordatorioService: ObservableObject {
    @Published var recordatorios: [Recordatorio] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    
    func insertRecordatorio(_ recordatorio: Recordatorio) async throws {
        _ = try await client
            .from("Recordatorio")
            .insert([recordatorio])
            .execute()
    }
    func fetchRecordatorios(forUser userID: String) async throws -> [Recordatorio] {
        let response: PostgrestResponse<[Recordatorio]> = try await client
            .from("Recordatorio")
            .select()
            .eq("id_usuario", value: userID)
            .order("id_recordatorio", ascending: true)
            .execute()
        return response.value
        
    }
    
    func deleteRecordatorio(_ recordatorio: Recordatorio) async {
        do {
            _ = try await client
                .from("Recordatorio")
                .delete()
                .eq("id_recordatorio", value: recordatorio.id_recordatorio)
                .execute()
            
        } catch {
            print("Error deleting recordatorio:", error)
            DispatchQueue.main.async {
                self.errorMessage = "Error al eliminar el recordatorio."
            }
        }
    }

}

