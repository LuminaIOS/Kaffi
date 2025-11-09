//
//  KaffiTests.swift
//  KaffiTests
//
//  Created by Amparo Alcaraz Tonella on 09/11/25.
//

import Testing
import Supabase
@testable import Kaffi

struct KaffiTests {
    @Test func testAPIFetch() async throws {
        let response = try await client
            .from("Lote")
            .select()
            .limit(1)
            .execute()
        #expect(response.status == 200, "Expected status 200, got \(response.status)")
        
    }
}
