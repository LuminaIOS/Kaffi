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
    @Test @MainActor
    func testFetchFincas() async {
        let vm = FincaViewModel(fincaService: FincaService(),supabase: client)
        
        do {
                try await vm.fetchFincas()
            } catch {
                //Solo esta este catch pq sino Xcode marca error
            }

        #expect(vm.errorMessage == "Sesión expirada. Inicia sesión nuevamente.")
        #expect(vm.fincas.isEmpty)
        #expect(vm.isLoading == false)
    }
    
    @Test @MainActor
    func testFetchCosechas() async {
        let vm = CosechaViewModel(cosechaService: CosechaService(), supabase: client)

        await vm.fetchCosechas()

        #expect(vm.errorMessage == "Sesión expirada. Inicia sesión nuevamente.")
        #expect(vm.cosechas.isEmpty)
        #expect(vm.isLoading == false)
    }


    @Test @MainActor
    func testFilterCosechasByFincaName() async {
        let vm = CosechaSearchViewModel(
            cosechaService: CosechaService(),
            fincaService: FincaService(),
            supabase: client
        )
        vm.fincas = [
            Finca(id_finca: 1,id_usuario: "usuario1",nombre_finca: "Finca Solecito",id_productor: 1,hectareas: 10, altitud: 1.2,variedades_cult: "Bourbon, Typica",porte_planta: "Medio",imagen: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQP8PnhM1MNuiVPyxVkOFg45Vd1c3svVWwL8w&s", id_coop: 1,lote: ["A123", "A124", "A126"],sombra_natural: 10, especies: "Muchas", arboles_mayores: 0),
            Finca(id_finca: 2,id_usuario: "usuario1",nombre_finca: "La Esperanza",id_productor: 1,hectareas: 10, altitud: 1.2,variedades_cult: "Bourbon, Typica",porte_planta: "Medio",imagen: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQP8PnhM1MNuiVPyxVkOFg45Vd1c3svVWwL8w&s", id_coop: 1,lote: ["A123", "A124", "A126"],sombra_natural: 10, especies: "Muchas", arboles_mayores: 0)
        ]
        
        vm.cosechas = [
            Cosecha(id_cosecha: 1, id_finca: 1),
            Cosecha(id_cosecha: 2, id_finca: 2)
        ]
        var searchText = "esper"
        
        var filteredCosechas: [Cosecha] {
            if searchText.isEmpty {
                return vm.cosechas
            }
            
            return vm.cosechas.filter { cosecha in
                if let finca = vm.fincas.first(where: { $0.id_finca == cosecha.id_finca }) {
                    return finca.nombre_finca.lowercased().contains(searchText.lowercased())
                }
                return false
            }
        }
        #expect(filteredCosechas.count == 1)
        #expect(filteredCosechas.first?.id_finca == 1)
        
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
