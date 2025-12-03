//
//  TecnicoService.swift
//  Trial
//
//  Created by Angela Rodriguez on 27/11/25.
//

import Foundation
import Supabase
import Combine

class TecnicoService: ObservableObject {
    @Published var tecnicos_control: [Tecnico] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    

    func insertTecnico(_ tecnico: Tecnico) async throws {
        _ = try await client
            .from("Tecnico_Control")
            .insert([tecnico])
            .execute()
    }

    
}
