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
    
    @Test @MainActor func FincaCamposOb() async throws {
        let vm = FincaViewModel(fincaService: FincaService())
        
        vm.finca = "Las Nubes"
        vm.productor = ""
        vm.estado = "Nuevo Leon"
        vm.ciudad = "Monterrey"
        vm.hectareas = 10
        
        await vm.registrarFinca()
        
        #expect (vm.mensajeAlerta == "Por favor llena campos obligatorios.")
        #expect (vm.tituloAlerta == "Campos obligatorios")
        #expect (vm.mostrandoAlerta == true)

    }
}
