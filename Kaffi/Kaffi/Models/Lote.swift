//
//  Finca.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 21/10/25.
//
import Foundation
import SwiftData

@Model
class Lote {
    var id: UUID
    var nombre: String
    var finca: String
    var ciudad: String
    var estado: String
    var cultivo: String
    var hectareas: Int
    var imagen: String
    var estatus: String

    init(id: UUID = UUID(), nombre: String, finca: String, ciudad: String, estado: String, cultivo: String, hectareas: Int, estatus: String, imagen: String) {
        self.id = id
        self.nombre = nombre
        self.finca = finca
        self.ciudad = ciudad
        self.estado = estado
        self.cultivo = cultivo
        self.hectareas = hectareas
        self.estatus = estatus
        self.imagen = imagen
    }
}
