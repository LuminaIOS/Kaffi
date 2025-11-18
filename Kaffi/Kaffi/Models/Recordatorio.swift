//
//  Recordatorio.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 17/11/25.
//

import Foundation
import SwiftData

@Model
class Recordatorio: Codable, Identifiable {
    var id_recordatorio: Int?
    var id_usuario: String
    var texto: String
    
    
    init(
        id_recordatorio: Int? = nil,
        id_usuario: String,
        texto: String
    ) {
        self.id_recordatorio = id_recordatorio
        self.id_usuario = id_usuario
        self.texto = texto
    }
    
    enum CodingKeys: String, CodingKey {
        case id_recordatorio, id_usuario, texto
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let id = id_recordatorio {   // only encode if it exists
            try container.encode(id, forKey: .id_recordatorio)
        }
        try container.encode(id_usuario, forKey: .id_usuario)
        try container.encode(texto, forKey: .texto)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_recordatorio = try container.decode(Int.self, forKey: .id_recordatorio)
        id_usuario = try container.decode(String.self, forKey: .id_usuario)
        texto = try container.decode(String.self, forKey: .texto)
    }
}

