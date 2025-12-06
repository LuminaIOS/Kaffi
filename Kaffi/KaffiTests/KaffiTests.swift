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
    
    @Test @MainActor
    func FincaCamposOb() async throws {
        let vm = FincaViewModel(fincaService: FincaService(), supabase: client)
        
        
        vm.finca = ""
        vm.hectareas = nil
        vm.altitud = nil
        vm.variedadesSeleccionadas = []
        vm.portePlanta = ""
        vm.sombra = nil
        vm.especieSeleccionadas = []
        vm.arboles = nil
        
        
        vm.selectedImageData = nil
        
        
        await vm.registrarFinca(productorId: nil)
        
        #expect(vm.tituloAlerta == "Campos obligatorios")
        #expect(vm.mensajeAlerta == "Por favor llena todos los campos obligatorios.")
        #expect(vm.mostrandoAlerta == true)
    }
    
    @Test @MainActor
    func TecnicoCamposOb() async throws {
        let vm = TecnicoViewModel(tecnicoService: TecnicoService(), supabase: client)
        

        vm.tecnico = ""
        vm.cargo = ""
        vm.visita = ""
        vm.resultado = ""
    
        

        await vm.registrarTecnico(fincaId: nil)
        
        #expect(vm.tituloAlerta == "Campos obligatorios")
        #expect(vm.mensajeAlerta == "Por favor llena todos los campos obligatorios.")
        #expect(vm.mostrandoAlerta == true)
    }
    
    @Test @MainActor
    func CosechaCamposob() async throws{
        let vm = CosechaViewModel(cosechaService: CosechaService(), supabase: client)
        
        vm.volumen = ""
        vm.inicioCosecha = ""
        vm.finCosecha = ""
        vm.procesamiento = ""
        vm.fermentacion = nil
        vm.secado = ""
        vm.subproductos = ""
        vm.tratamientoAgua = ""
        vm.emisiones = nil
        vm.capturaArboles = nil
        vm.emisionesNetas = nil
        vm.aguaBeneficio = nil
        vm.aguaRiego = nil
        vm.huellaTotal = ""
        vm.catacion = nil
        vm.sensorial = ""
        vm.empaque = ""
        vm.nutricional = ""
        vm.selectedImageData = nil

     
        await vm.registrarCosecha(fincaId: nil)


        #expect(vm.mostrandoAlerta == true)
        #expect(vm.tituloAlerta == "Campos obligatorios")
        #expect(vm.mensajeAlerta == "Por favor llena todos los campos obligatorios.")
        
    }
    @Test @MainActor
    func ProductorCamposOb() async throws {

        let vm = ProductorViewModel(productorService: ProductorService(),supabase: client)

        vm.nombre = ""
        vm.edad = nil
        vm.genero = ""
        vm.generacion = ""
        vm.ubicacion = ""
        vm.comunidad = ""
        vm.latitud = nil
        vm.longitud = nil
        vm.testimonio = ""

        await vm.registrarProductor()

        #expect(vm.tituloAlerta == "Campos obligatorios")
        #expect(vm.mensajeAlerta == "Por favor llena todos los campos obligatorios.")
        #expect(vm.mostrandoAlerta == true)
    }


}



    
//    @Test @MainActor func testDetailsViewWithMockData() async {
//        let testLote = Lote(
//            id_lote: 999,
//            id_usuario: "test-user-123",
//            id_finca: 888,
//            nombre_finca: "Finca de Prueba",
//            nombre: "Lote Test",
//            cultivo: "Arabica",
//            hectareas: 5,
//            estatus: "Activo",
//            imagen: "https://example.com/test.jpg"
//        )
//        
//        let detailsView = DetailsView(lote: testLote)
//        
//        #expect(detailsView.lote.id_lote == 999)
//        #expect(detailsView.lote.nombre == "Lote Test")
//        #expect(detailsView.lote.cultivo == "Arabica")
//        #expect(detailsView.lote.nombre_finca == "Finca de Prueba")
//    }
//    
//    @Test @MainActor func testLoteDetailViewModel() async {
//        let viewModel = LoteDetailViewModel()
//        let testLote = Lote(
//            id_lote: 1,
//            id_usuario: "test-user",
//            id_finca: 1,
//            nombre_finca: "Test Finca",
//            nombre: "Test Lote",
//            cultivo: "Test",
//            hectareas: 10,
//            estatus: "En producción"
//        )
//        
//        #expect(viewModel.isLoading == false)
//        #expect(viewModel.loteDetail == nil)
//        #expect(viewModel.errorMessage == nil)
//        
//        await viewModel.cargarDetalles(lote: testLote)
//        
//        #expect(viewModel.isLoading == false) 
//    }
//}
