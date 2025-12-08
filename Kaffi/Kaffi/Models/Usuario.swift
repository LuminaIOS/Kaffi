//
//
//

import Foundation

struct Usuario: Codable, Identifiable {
    let id: String
    let username: String
    let nombreCompleto: String
    let birthdate: String?
    let cooperativa: String?
    let rol: String?
    let foto_url: String?
    let created_at: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id_usuario"
        case username
        case nombreCompleto
        case birthdate
        case cooperativa = "Cooperativa"
        case rol = "rol"
        case foto_url = "foto_url"
        case created_at = "created_at"
    }
}
