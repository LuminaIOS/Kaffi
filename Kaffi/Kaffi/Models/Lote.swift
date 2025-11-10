//
//  Finca.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 21/10/25.
//

import Foundation
import SwiftData

@Model
class Lote: Codable, Identifiable {
    var id_lote: Int?
    var id_usuario: String
    var id_finca: Int
    var nombre_finca: String
    var nombre: String
    var cultivo: String
    var hectareas: Int
    var estatus: String
    var imagen: String?

    init(id_lote: Int? = nil, id_usuario: String, id_finca: Int,nombre_finca: String, nombre: String, cultivo: String, hectareas: Int, estatus: String, imagen: String? = nil) {
        self.id_lote = id_lote
        self.id_usuario = id_usuario
        self.id_finca = id_finca
        self.nombre_finca = nombre_finca
        self.nombre = nombre
        self.cultivo = cultivo
        self.hectareas = hectareas
        self.estatus = estatus
        self.imagen = imagen
    }
    enum CodingKeys: String, CodingKey {
        case id_lote, id_usuario, id_finca, nombre_finca, nombre, cultivo, hectareas, estatus, imagen
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let id_lote = id_lote {
            try container.encode(id_lote, forKey: .id_lote) // <- CORREGIDO: era .nombre_finca
        }
        try container.encode(id_usuario, forKey: .id_usuario)
        try container.encode(id_finca, forKey: .id_finca)
        try container.encode(nombre_finca, forKey: .nombre_finca)
        try container.encode(nombre, forKey: .nombre)
        try container.encode(cultivo, forKey: .cultivo)
        try container.encode(hectareas, forKey: .hectareas)
        try container.encode(estatus, forKey: .estatus)
        try container.encodeIfPresent(imagen, forKey: .imagen)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_lote = try container.decode(Int.self, forKey: .id_lote)
        id_usuario = try container.decode(String.self, forKey: .id_usuario)
        id_finca = try container.decode(Int.self, forKey: .id_finca)
        nombre_finca = try container.decode(String.self, forKey: .nombre_finca)
        nombre = try container.decode(String.self, forKey: .nombre)
        cultivo = try container.decode(String.self, forKey: .cultivo)
        hectareas = try container.decode(Int.self, forKey: .hectareas)
        estatus = try container.decode(String.self, forKey: .estatus)
        imagen = try container.decodeIfPresent(String.self, forKey: .imagen)
        
    }
}

