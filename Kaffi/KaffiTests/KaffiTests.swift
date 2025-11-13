//
//  KaffiTests.swift
//  KaffiTests
//
//  Created by Amparo Alcaraz Tonella on 09/11/25.
//

import Testing
import SwiftUI
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
        
        #expect(vm.mensajeAlerta == "Por favor llena campos obligatorios.")
        #expect(vm.tituloAlerta == "Campos obligatorios")
        #expect(vm.mostrandoAlerta == true)
    }
    
    @Test @MainActor func testDetailsViewWithMockData() async {
        let testLote = Lote(
            id_lote: 999,
            id_usuario: "test-user-123",
            id_finca: 888,
            nombre_finca: "Finca de Prueba",
            nombre: "Lote Test",
            cultivo: "Arabica",
            hectareas: 5,
            estatus: "Activo",
            imagen: "https://example.com/test.jpg"
        )
        
        let detailsView = DetailsView(lote: testLote)
        
        #expect(detailsView.lote.id_lote == 999)
        #expect(detailsView.lote.nombre == "Lote Test")
        #expect(detailsView.lote.cultivo == "Arabica")
        #expect(detailsView.lote.nombre_finca == "Finca de Prueba")
    }
    
    @Test @MainActor func testLoteDetailViewModel() async {
        let viewModel = LoteDetailViewModel()
        let testLote = Lote(
            id_lote: 1,
            id_usuario: "test-user",
            id_finca: 1,
            nombre_finca: "Test Finca",
            nombre: "Test Lote",
            cultivo: "Test",
            hectareas: 10,
            estatus: "En producción"
        )
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.loteDetail == nil)
        #expect(viewModel.errorMessage == nil)
        
        await viewModel.cargarDetalles(lote: testLote)
        
        #expect(viewModel.isLoading == false) 
    }
}
