//
//  FincaService.swift
//  Kaffi
//
//  Created by Angela Rodriguez on 05/11/25.
//

import Foundation
import Supabase


// service de finca
class FincaService {
    
    func insertFinca(_ finca: Finca) async throws {
        _ = try await client
            .from("Finca")
            .insert([finca])
            .execute()
    }
}


