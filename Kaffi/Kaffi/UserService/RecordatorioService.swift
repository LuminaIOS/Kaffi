//
//  RecordatorioService.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 18/11/25.
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
    
    func fetchRecordatorios() async {
        isLoading = true
        errorMessage = nil
        do {
            let response: PostgrestResponse<[Recordatorio]> = try await client
                .from("Recordatorio")
                .select()
                .order("id_recordatorio", ascending: true)
                .execute()
            recordatorios = response.value
            if recordatorios.isEmpty {
                print("Respuesta vacía:", response)
                
            } else {
                print(response.data)
                let raw = try await client.from("Recordatorio").select().execute()
                print(String(data: raw.data, encoding: .utf8)!)

            }
        } catch {
            print(error)
            errorMessage = "Error al cargar los recordatorios."
        }
        isLoading = false
    }
    func deleteRecordatorio(_ recordatorio: Recordatorio) async {
        do {
            _ = try await client
                .from("Recordatorio")
                .delete()
                .eq("id_recordatorio", value: recordatorio.id_recordatorio)
                .execute()
            
            // Remove it locally too
            DispatchQueue.main.async {
                self.recordatorios.removeAll { $0.id_recordatorio == recordatorio.id_recordatorio }
            }
        } catch {
            print("Error deleting recordatorio:", error)
            DispatchQueue.main.async {
                self.errorMessage = "Error al eliminar el recordatorio."
            }
        }
    }

}

