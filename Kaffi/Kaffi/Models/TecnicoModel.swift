//
//  TecnicoModel.swift
//  Trial
//
//  Created by Angela Rodriguez on 27/11/25.
//

import Foundation

class Tecnico: Codable, Identifiable {
    var id_finca: Int
    var id_usuario: String
    var fecha_creacion: Date = Date()
    var nombre_respo: String
    var cargo: String
    var tipo_visita: String
    var fecha_reg: Date = Date()
    var resultado: String

    init(
        id_finca: Int? = nil,
        id_usuario: String,
        nombre_respo: String,
        cargo: String,
        tipo_visita: String,
        fecha_reg: Date = Date(),
        resultado: String
    ) {
        self.id_finca = id_finca!
        self.id_usuario = id_usuario
        self.nombre_respo = nombre_respo
        self.cargo = cargo
        self.tipo_visita = tipo_visita
        self.fecha_reg = fecha_reg
        self.resultado = resultado
    }

    enum CodingKeys: String, CodingKey {
        case id_finca, id_usuario, fecha_creacion, nombre_respo, cargo, tipo_visita, fecha_reg, resultado
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id_finca, forKey: .id_finca)
        try container.encode(id_usuario, forKey: .id_usuario)
        try container.encode(fecha_creacion, forKey: .fecha_creacion)
        try container.encode(nombre_respo, forKey: .nombre_respo)
        try container.encode(cargo, forKey: .cargo)
        try container.encode(tipo_visita, forKey: .tipo_visita)
        try container.encode(fecha_reg, forKey: .fecha_reg)
        try container.encode(resultado, forKey: .resultado)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_finca = try container.decodeIfPresent(Int.self, forKey: .id_finca)!
        id_usuario = try container.decode(String.self, forKey: .id_usuario)
        fecha_creacion = try container.decodeIfPresent(Date.self, forKey: .fecha_creacion) ?? Date()
        nombre_respo = try container.decode(String.self, forKey: .nombre_respo)
        cargo = try container.decode(String.self, forKey: .cargo)
        tipo_visita = try container.decode(String.self, forKey: .tipo_visita)
        fecha_reg = try container.decodeIfPresent(Date.self, forKey: .fecha_reg) ?? Date()
        resultado = try container.decode(String.self, forKey: .resultado)
    }
}

