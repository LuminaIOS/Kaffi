//
//  CosechaModel.swift
//  Trial
//
//  Created by Angela Rodriguez on 26/11/25.
//

import Foundation

class Cosecha: Codable, Identifiable {
    
    var id_cosecha: Int?
    var created_at: Date = Date()
    
    var volumen: String?
    var inicio_cosecha: String?
    var fin_cosecha: String?
    var procesamiento: String?
    var fermentacion: Int?
    var secado: String?
    var subproductos: String?
    var tratamiento_agua: String?
    
    var emisiones_carbono: Float?
    var emisiones_captura: Float?
    var emisiones_neto: Float?
    
    var agua_beneficio: Float?
    var agua_riego: Float?
    var agua_huella: String?
    
    var id_usuario: String?
    var id_finca: Int?
    var id_coop: Int?
    
    var puntaje_catacion: Float?
    var perfil_sensorial: String?
    var empaque: String?
    var contenido_nutricional: String?
    
    var imagen_cosecha: String?
    
    
 
    init(
        id_cosecha: Int? = nil,
        created_at: Date = Date(),
        volumen: String? = nil,
        inicio_cosecha: String? = nil,
        fin_cosecha: String? = nil,
        procesamiento: String? = nil,
        fermentacion: Int? = nil,
        secado: String? = nil,
        subproductos: String? = nil,
        tratamiento_agua: String? = nil,
        emisiones_carbono: Float? = nil,
        emisiones_captura: Float? = nil,
        emisiones_neto: Float? = nil,
        agua_beneficio: Float? = nil,
        agua_riego: Float? = nil,
        agua_huella: String? = nil,
        id_usuario: String? = nil,
        id_finca: Int? = nil,
        id_coop: Int? = nil,
        puntaje_catacion: Float? = nil,
        perfil_sensorial: String? = nil,
        empaque: String? = nil,
        contenido_nutricional: String? = nil,
        imagen_cosecha: String? = nil

    ) {
        self.id_cosecha = id_cosecha
        self.created_at = created_at
        self.volumen = volumen
        self.inicio_cosecha = inicio_cosecha
        self.fin_cosecha = fin_cosecha
        self.procesamiento = procesamiento
        self.fermentacion = fermentacion
        self.secado = secado
        self.subproductos = subproductos
        self.tratamiento_agua = tratamiento_agua
        self.emisiones_carbono = emisiones_carbono
        self.emisiones_captura = emisiones_captura
        self.emisiones_neto = emisiones_neto
        self.agua_beneficio = agua_beneficio
        self.agua_riego = agua_riego
        self.agua_huella = agua_huella
        self.id_usuario = id_usuario
        self.id_finca = id_finca
        self.id_coop = id_coop
        self.puntaje_catacion = puntaje_catacion
        self.perfil_sensorial = perfil_sensorial
        self.empaque = empaque
        self.contenido_nutricional = contenido_nutricional
        self.imagen_cosecha = imagen_cosecha
    }

    

    enum CodingKeys: String, CodingKey {
        case id_cosecha, created_at, volumen, inicio_cosecha, fin_cosecha
        case procesamiento, fermentacion, secado, subproductos, tratamiento_agua
        case emisiones_carbono, emisiones_captura, emisiones_neto
        case agua_beneficio, agua_riego, agua_huella
        case id_usuario, id_finca, id_coop
        case puntaje_catacion, perfil_sensorial, empaque, contenido_nutricional
        case imagen_cosecha

    }

    

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let id = id_cosecha { try container.encode(id, forKey: .id_cosecha) }
        
        try container.encode(created_at, forKey: .created_at)
        try container.encodeIfPresent(volumen, forKey: .volumen)
        try container.encodeIfPresent(inicio_cosecha, forKey: .inicio_cosecha)
        try container.encodeIfPresent(fin_cosecha, forKey: .fin_cosecha)
        try container.encodeIfPresent(procesamiento, forKey: .procesamiento)
        try container.encodeIfPresent(fermentacion, forKey: .fermentacion)
        try container.encodeIfPresent(secado, forKey: .secado)
        try container.encodeIfPresent(subproductos, forKey: .subproductos)
        try container.encodeIfPresent(tratamiento_agua, forKey: .tratamiento_agua)
        
        try container.encodeIfPresent(emisiones_carbono, forKey: .emisiones_carbono)
        try container.encodeIfPresent(emisiones_captura, forKey: .emisiones_captura)
        try container.encodeIfPresent(emisiones_neto, forKey: .emisiones_neto)
        
        try container.encodeIfPresent(agua_beneficio, forKey: .agua_beneficio)
        try container.encodeIfPresent(agua_riego, forKey: .agua_riego)
        try container.encodeIfPresent(agua_huella, forKey: .agua_huella)
        
        try container.encodeIfPresent(id_usuario, forKey: .id_usuario)
        try container.encodeIfPresent(id_finca, forKey: .id_finca)
        try container.encodeIfPresent(id_coop, forKey: .id_coop)
        
        try container.encodeIfPresent(puntaje_catacion, forKey: .puntaje_catacion)
        try container.encodeIfPresent(perfil_sensorial, forKey: .perfil_sensorial)
        try container.encodeIfPresent(empaque, forKey: .empaque)
        try container.encodeIfPresent(contenido_nutricional, forKey: .contenido_nutricional)
        try container.encodeIfPresent(imagen_cosecha, forKey: .imagen_cosecha)

    }

    

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id_cosecha = try container.decodeIfPresent(Int.self, forKey: .id_cosecha)
        created_at = try container.decodeIfPresent(Date.self, forKey: .created_at) ?? Date()
        
        volumen = try container.decodeIfPresent(String.self, forKey: .volumen)
        inicio_cosecha = try container.decodeIfPresent(String.self, forKey: .inicio_cosecha)
        fin_cosecha = try container.decodeIfPresent(String.self, forKey: .fin_cosecha)
        procesamiento = try container.decodeIfPresent(String.self, forKey: .procesamiento)
        fermentacion = try container.decodeIfPresent(Int.self, forKey: .fermentacion)
        secado = try container.decodeIfPresent(String.self, forKey: .secado)
        subproductos = try container.decodeIfPresent(String.self, forKey: .subproductos)
        tratamiento_agua = try container.decodeIfPresent(String.self, forKey: .tratamiento_agua)
        
        emisiones_carbono = try container.decodeIfPresent(Float.self, forKey: .emisiones_carbono)
        emisiones_captura = try container.decodeIfPresent(Float.self, forKey: .emisiones_captura)
        emisiones_neto = try container.decodeIfPresent(Float.self, forKey: .emisiones_neto)
        
        agua_beneficio = try container.decodeIfPresent(Float.self, forKey: .agua_beneficio)
        agua_riego = try container.decodeIfPresent(Float.self, forKey: .agua_riego)
        agua_huella = try container.decodeIfPresent(String.self, forKey: .agua_huella)
        
        id_usuario = try container.decodeIfPresent(String.self, forKey: .id_usuario)
        id_finca = try container.decodeIfPresent(Int.self, forKey: .id_finca)
        id_coop = try container.decodeIfPresent(Int.self, forKey: .id_coop)
        
        puntaje_catacion = try container.decodeIfPresent(Float.self, forKey: .puntaje_catacion)
        perfil_sensorial = try container.decodeIfPresent(String.self, forKey: .perfil_sensorial)
        empaque = try container.decodeIfPresent(String.self, forKey: .empaque)
        contenido_nutricional = try container.decodeIfPresent(String.self, forKey: .contenido_nutricional)
        imagen_cosecha = try container.decodeIfPresent(String.self, forKey: .imagen_cosecha)

    }
}

