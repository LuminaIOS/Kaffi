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
    var nombre: String
    var ciudad: String
    var estado: String
    var descripcion: String
    var hectareas: Int
    var lotes: Int
    var imagen: String

    init(id: UUID = UUID(), nombre: String, ciudad: String, estado: String, descripcion: String, hectareas: Int, lotes: Int,  imagen: String) {
        self.id = id
        self.nombre = nombre
        self.ciudad = ciudad
        self.estado = estado
        self.descripcion = descripcion
        self.hectareas = hectareas
        self.lotes = lotes
        self.imagen = imagen
    }
}
