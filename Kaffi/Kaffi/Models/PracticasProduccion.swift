//
//  PracticasProduccion.swift
//  Kaffi
//

import Foundation

class PracticasProduccion: Codable, Identifiable {
    var idPractica: Int?
    var id_usuario: String
    var id_finca: Int?
    var manejo_suelo: [String]
    var control_plagas: [String]
    var riego: String
    var certificaciones: [String]
    
    init(
        idPractica: Int? = nil,
        id_usuario: String,
        id_finca: Int? = nil,
        manejo_suelo: [String],
        control_plagas: [String],
        riego: String,
        certificaciones: [String]
    ) {
        self.idPractica = idPractica
        self.id_usuario = id_usuario
        self.id_finca = id_finca
        self.manejo_suelo = manejo_suelo
        self.control_plagas = control_plagas
        self.riego = riego
        self.certificaciones = certificaciones
    }
    
    enum CodingKeys: String, CodingKey {
        case idPractica, id_usuario, id_finca
        case manejo_suelo, control_plagas, riego, certificaciones
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        idPractica = try container.decodeIfPresent(Int.self, forKey: .idPractica)
        id_usuario = try container.decode(String.self, forKey: .id_usuario)
        id_finca = try container.decodeIfPresent(Int.self, forKey: .id_finca)
        manejo_suelo = try container.decode([String].self, forKey: .manejo_suelo)
        control_plagas = try container.decode([String].self, forKey: .control_plagas)
        riego = try container.decode(String.self, forKey: .riego)
        certificaciones = try container.decode([String].self, forKey: .certificaciones)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(idPractica, forKey: .idPractica)
        try container.encode(id_usuario, forKey: .id_usuario)
        try container.encodeIfPresent(id_finca, forKey: .id_finca)
        try container.encode(manejo_suelo, forKey: .manejo_suelo)
        try container.encode(control_plagas, forKey: .control_plagas)
        try container.encode(riego, forKey: .riego)
        try container.encode(certificaciones, forKey: .certificaciones)
    }
}
