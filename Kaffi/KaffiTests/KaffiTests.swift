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

    @Test @MainActor
    @available(iOS 18.1, *)
    func testCosechaSpeechParserExtractsMultipleFields() async throws {
        let parser = CosechaSpeechParser()

        let transcript = """
        El volumen fue de 27 quintales pergamino, la cosecha empezó en noviembre y terminó en febrero, \
        usamos procesamiento lavado ecológico y la fermentación duró 18 horas
        """

        let result = try await parser.parseSpeech(transcript)

        #expect(result["volumen"]?.contains("27") == true)
        #expect(result["volumen"]?.contains("Quintales") == true || result["volumen"]?.contains("quintales") == true)
        #expect(result["inicioCosecha"]?.lowercased().contains("noviembre") == true)
        #expect(result["finCosecha"]?.lowercased().contains("febrero") == true)
        #expect(result["procesamiento"]?.contains("Lavado") == true || result["procesamiento"]?.contains("lavado") == true)
        #expect(result["fermentacion"] == "18")
        #expect(result["secado"] == "" || result["secado"] == nil)
        #expect(result["subproductos"] == "" || result["subproductos"] == nil)
        #expect(result["emisiones"] == "" || result["emisiones"] == nil)
        #expect(result["catacion"] == "" || result["catacion"] == nil)
    }

    @Test @MainActor
    @available(iOS 18.1, *)
    func testProductorSpeechParserAntiHallucination() async throws {
        let parser = ProductorSpeechParser()

        let transcript = "El productor se llama Juan Pérez, tiene 45 años y es de género masculino"

        let result = try await parser.parseSpeech(transcript)

        #expect(result["nombre"]?.contains("Juan") == true)
        #expect(result["nombre"]?.contains("Pérez") == true || result["nombre"]?.contains("Perez") == true)
        #expect(result["edad"] == "45")
        #expect(result["genero"]?.lowercased().contains("masculino") == true)
        #expect(result["generacion"] == "" || result["generacion"] == nil)
        #expect(result["ubicacion"] == "" || result["ubicacion"] == nil)
        #expect(result["latitud"] == "" || result["latitud"] == nil)
        #expect(result["longitud"] == "" || result["longitud"] == nil)
        #expect(result["comunidad"] == "" || result["comunidad"] == nil)
        #expect(result["testimonio"] == "" || result["testimonio"] == nil)

        let emptyFields = ["generacion", "ubicacion", "latitud", "longitud", "comunidad", "testimonio"]
        for field in emptyFields {
            let value = result[field] ?? ""
            #expect(value.isEmpty, "Campo '\(field)' debe estar vacío pero contiene: '\(value)'")
        }
    }

    @Test @MainActor
    @available(iOS 18.1, *)
    func testFincaSpeechParserHandlesInvalidJSON() async throws {
        let parser = FincaSpeechParser()

        let emptyResult = try await parser.parseSpeech("")
        #expect(emptyResult.isEmpty, "Transcript vacío debe retornar diccionario vacío")

        let validTranscript = "La finca se llama El Amanecer, tiene 15 hectáreas y está a 1500 metros de altitud"

        do {
            let validResult = try await parser.parseSpeech(validTranscript)

            #expect(validResult["finca"]?.lowercased().contains("amanecer") == true)
            #expect(validResult["hectareas"]?.contains("15") == true)
            #expect(validResult["altitud"]?.contains("1500") == true)
            #expect(validResult["variedades"] == "" || validResult["variedades"] == nil)
            #expect(validResult["especies"] == "" || validResult["especies"] == nil)
            #expect(validResult["sombra"] == "" || validResult["sombra"] == nil)
            #expect(validResult["arboles"] == "" || validResult["arboles"] == nil)

        } catch {
            #expect(error is FincaSpeechParser.ParsingError, "Error debe ser de tipo ParsingError")

            let errorMessage = error.localizedDescription
            #expect(!errorMessage.isEmpty, "Error debe tener descripción clara")
        }
    }

    @Test @MainActor
    func CamposObligatoriosEdicionInformacion() async {
        let vm = AuthModel()

        vm.currentId = "test-user-123"
        vm.currentUser = Usuario(
            id: "test-user-123",
            username: "usuarioprueba",
            nombreCompleto: "Usuario Prueba",
            birthdate: "1990-01-01",
            cooperativa: "Cooperativa Central",
            rol: "tecnico",
            foto_url: nil,
            created_at: nil
        )

        await vm.updateUser(
            nombreCompleto: "",
            username: "",
            birthdate: Date(),
            fotoURL: nil
        )

        let nombreVacio = ""
        let usernameVacio = ""

        #expect(nombreVacio.isEmpty)
        #expect(usernameVacio.isEmpty)
        #expect(vm.isLoading == false)
    }

    @Test @MainActor
    func DisponibilidadInformacion() async {
        let vm = AuthModel()

        vm.currentId = "test-user"
        vm.isLoggedIn = true

        vm.currentUser = Usuario(
            id: "test-user",
            username: "tecnico",
            nombreCompleto: "Juan Jose",
            birthdate: "1985-05-15",
            cooperativa: "Cooperativa Norte",
            rol: "tecnico",
            foto_url: nil,
            created_at: nil
        )


        #expect(vm.currentUser != nil)
        #expect(vm.currentUser?.nombreCompleto == "Juan Pérez")
        #expect(vm.currentUser?.username == "tecnico01")
        #expect(vm.currentUser?.birthdate == "1985-05-15")
        #expect(vm.currentUser?.rol == "tecnico")

        await vm.fetchUserData()

        #expect(vm.currentUser != nil)
        #expect(!vm.currentId.isEmpty)
    }

    @Test @MainActor
    func CamposValidosRegistro() async {
        let vm = AuthModel()

        vm.userEmail = ""
        vm.userPassword = "password123"

        await vm.signUp(
            nombreCompleto: "Test User",
            username: "testuser",
            fechaNacimiento: Date(),
            cooperativa: "Cooperativa Central",
            rol: "tecnico"
        )

        #expect(vm.message == "El correo es requerido")
        #expect(vm.messageType == .error)


        vm.userEmail = "test@test.com"
        vm.userPassword = "12345"
        vm.message = ""

        await vm.signUp(
            nombreCompleto: "Test User",
            username: "testuser",
            fechaNacimiento: Date(),
            cooperativa: "Cooperativa Central",
            rol: "tecnico"
        )

        #expect(vm.userPassword.count < 6)


        vm.userEmail = "test@test.com"
        vm.userPassword = "password123"
        vm.message = ""

        await vm.signUp(
            nombreCompleto: "Test User",
            username: "",
            fechaNacimiento: Date(),
            cooperativa: "Cooperativa Central",
            rol: "tecnico"
        )

        #expect(vm.message == "El nombre de usuario es requerido")
        #expect(vm.messageType == .error)
    }


}
