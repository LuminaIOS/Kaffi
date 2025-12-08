//
//
//

import Foundation

class Finca: Codable, Identifiable {

    var id_finca: Int?
    var id_usuario: String?
    var fecha_creacion: Date = Date()
    var nombre_finca: String
    var id_productor: Int?
    var hectareas: Int
    var altitud: Double
    var variedades_cult: String
    var porte_planta: String
    var imagen: String?
    var id_coop: Int?
    var lote: [String]?
    var sombra_natural: Int? = 0
    var especies: String?
    var arboles_mayores: Int? = 0

    init(
        id_finca: Int? = nil,
        id_usuario: String,
        nombre_finca: String,
        id_productor: Int? = nil,
        hectareas: Int,
        altitud: Double,
        variedades_cult: String,
        porte_planta: String,
        imagen: String? = nil,
        id_coop: Int? = nil,
        lote: [String]? = nil,
        sombra_natural: Int? = 0,
        especies: String? = nil,
        arboles_mayores: Int? = 0
    ) {
        self.id_finca = id_finca
        self.id_usuario = id_usuario
        self.nombre_finca = nombre_finca
        self.id_productor = id_productor
        self.hectareas = hectareas
        self.altitud = altitud
        self.variedades_cult = variedades_cult
        self.porte_planta = porte_planta
        self.imagen = imagen
        self.id_coop = id_coop
        self.lote = lote
        self.sombra_natural = sombra_natural
        self.especies = especies
        self.arboles_mayores = arboles_mayores
    }


    enum CodingKeys: String, CodingKey {
        case id_finca, id_usuario, fecha_creacion, nombre_finca, id_productor, hectareas, altitud
        case variedades_cult, porte_planta, imagen, id_coop, lote, sombra_natural, especies, arboles_mayores
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let id = id_finca { try container.encode(id, forKey: .id_finca) }
        try container.encode(id_usuario, forKey: .id_usuario)
        try container.encode(fecha_creacion, forKey: .fecha_creacion)
        try container.encode(nombre_finca, forKey: .nombre_finca)
        try container.encode(id_productor, forKey: .id_productor)
        try container.encode(hectareas, forKey: .hectareas)
        try container.encode(altitud, forKey: .altitud)
        try container.encode(variedades_cult, forKey: .variedades_cult)
        try container.encode(porte_planta, forKey: .porte_planta)
        try container.encodeIfPresent(imagen, forKey: .imagen)
        try container.encodeIfPresent(id_coop, forKey: .id_coop)
        try container.encodeIfPresent(lote, forKey: .lote)
        try container.encodeIfPresent(sombra_natural, forKey: .sombra_natural)
        try container.encodeIfPresent(especies, forKey: .especies)
        try container.encodeIfPresent(arboles_mayores, forKey: .arboles_mayores)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id_finca = try container.decodeIfPresent(Int.self, forKey: .id_finca)
        id_usuario = try container.decode(String.self, forKey: .id_usuario)
        fecha_creacion = try container.decodeIfPresent(Date.self, forKey: .fecha_creacion) ?? Date()
        nombre_finca = try container.decode(String.self, forKey: .nombre_finca)
        id_productor = try container.decode(Int.self, forKey: .id_productor)
        hectareas = try container.decode(Int.self, forKey: .hectareas)
        altitud = try container.decode(Double.self, forKey: .altitud)
        variedades_cult = try container.decode(String.self, forKey: .variedades_cult)
        porte_planta = try container.decode(String.self, forKey: .porte_planta)
        imagen = try container.decodeIfPresent(String.self, forKey: .imagen)
        id_coop = try container.decodeIfPresent(Int.self, forKey: .id_coop)
        lote = try container.decodeIfPresent([String].self, forKey: .lote)
        sombra_natural = try container.decodeIfPresent(Int.self, forKey: .sombra_natural) ?? 0
        especies = try container.decodeIfPresent(String.self, forKey: .especies)
        arboles_mayores = try container.decodeIfPresent(Int.self, forKey: .arboles_mayores) ?? 0
    }
}

extension Finca {
    var id: Int { id_finca ?? 0 }
}



