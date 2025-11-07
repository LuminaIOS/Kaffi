//
//  Finca.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 22/10/25.
//

import Foundation
import SwiftData

@Model
class Finca: Codable, Identifiable {
    var id_finca: Int?   // Make it optional
    var nombre_finca: String
    var productor: String
    var estado: String
    var ciudad: String
    var latitud: Double
    var longitud: Double
    var hectareas: Int
    var altitud: Double
    var suelo: String
    var descripcion: String
    var id_usuario: String?
    var imagen: String?
    
    init(
        id_finca: Int? = nil, // optional here
        nombre_finca: String,
        productor: String,
        estado: String,
        ciudad: String,
        latitud: Double,
        longitud: Double,
        hectareas: Int,
        altitud: Double,
        suelo: String,
        descripcion: String,
        id_usuario: String? = nil,
        imagen: String? = nil
    ) {
        self.id_finca = id_finca
        self.nombre_finca = nombre_finca
        self.productor = productor
        self.estado = estado
        self.ciudad = ciudad
        self.latitud = latitud
        self.longitud = longitud
        self.hectareas = hectareas
        self.altitud = altitud
        self.suelo = suelo
        self.descripcion = descripcion
        self.id_usuario = id_usuario
        self.imagen = imagen
    }
    
    enum CodingKeys: String, CodingKey {
        case id_finca, nombre_finca, productor, estado, ciudad, latitud, longitud, hectareas, altitud, suelo, descripcion, id_usuario,imagen
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let id = id_finca {   // only encode if it exists
            try container.encode(id, forKey: .id_finca)
        }
        try container.encode(nombre_finca, forKey: .nombre_finca)
        try container.encode(productor, forKey: .productor)
        try container.encode(estado, forKey: .estado)
        try container.encode(ciudad, forKey: .ciudad)
        try container.encode(latitud, forKey: .latitud)
        try container.encode(longitud, forKey: .longitud)
        try container.encode(hectareas, forKey: .hectareas)
        try container.encode(altitud, forKey: .altitud)
        try container.encode(suelo, forKey: .suelo)
        try container.encode(descripcion, forKey: .descripcion)
        try container.encodeIfPresent(id_usuario, forKey: .id_usuario)
        try container.encodeIfPresent(imagen, forKey: .imagen)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_finca = try container.decode(Int.self, forKey: .id_finca)
        nombre_finca = try container.decode(String.self, forKey: .nombre_finca)
        productor = try container.decode(String.self, forKey: .productor)
        estado = try container.decode(String.self, forKey: .estado)
        ciudad = try container.decode(String.self, forKey: .ciudad)
        latitud = try container.decode(Double.self, forKey: .latitud)
        longitud = try container.decode(Double.self, forKey: .longitud)
        hectareas = try container.decode(Int.self, forKey: .hectareas)
        altitud = try container.decode(Double.self, forKey: .altitud)
        suelo = try container.decode(String.self, forKey: .suelo)
        descripcion = try container.decode(String.self, forKey: .descripcion)
        id_usuario = try container.decodeIfPresent(String.self, forKey: .id_usuario)
        imagen = try container.decodeIfPresent(String.self, forKey: .imagen)
        
    }
}

