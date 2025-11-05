//
//  Finca.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 22/10/25.
//

import Foundation
import SwiftData

@Model
class Finca {
    var id: UUID
    var usuario: String
    var nombre: String
    var ciudad: String
    var estado: String
    var descripcion: String
    var hectareas: Int
    var imagen: String
    var latitud: Double
    var longitud: Double
    var altitud: Double

    init(id: UUID = UUID(), usuario: String, nombre: String, ciudad: String, estado: String, descripcion: String, hectareas: Int, imagen: String, latitud: Double, longitud: Double, altitud: Double) {
        self.id = id
        self.usuario = usuario
        self.nombre = nombre
        self.ciudad = ciudad
        self.estado = estado
        self.descripcion = descripcion
        self.hectareas = hectareas
        self.imagen = imagen
        self.latitud = latitud
        self.longitud = longitud
        self.altitud = altitud
    }
}
