//
//  Usuario.swift
//  Kaffi
//
//  Created by Bernardo Torres on 17/11/25.
//

import Foundation

struct Usuario: Codable, Identifiable {
    let id: String
    let username: String
    let nombreCompleto: String
    let birthdate: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id_usuario"
        case username
        case nombreCompleto
        case birthdate
    }
}
