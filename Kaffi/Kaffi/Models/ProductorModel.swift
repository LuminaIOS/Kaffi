//
//
//

import Foundation

class Productor: Codable, Identifiable {

    var idProductor: Int?
    var Nombre: String
    var Edad: Int?
    var Genero: String?
    var Generacion: String?
    var Ubicacion: String?
    var Latitud: Double?
    var Longitud: Double?
    var Comunidad: String?
    var Foto: String?
    var Video: String?
    var Testimonio: String?

    var idFinca: Int?
    var idTecnico: String?

    init(
        idProductor: Int? = nil,
        Nombre: String,
        Edad: Int? = nil,
        Genero: String? = nil,
        Generacion: String? = nil,
        Ubicacion: String? = nil,
        Latitud: Double? = nil,
        Longitud: Double? = nil,
        Comunidad: String? = nil,
        Foto: String? = nil,
        Video: String? = nil,
        Testimonio: String? = nil,
        idFinca: Int? = nil,
        idTecnico: String? = nil
    ) {
        self.idProductor = idProductor
        self.Nombre = Nombre
        self.Edad = Edad
        self.Genero = Genero
        self.Generacion = Generacion
        self.Ubicacion = Ubicacion
        self.Latitud = Latitud
        self.Longitud = Longitud
        self.Comunidad = Comunidad
        self.Foto = Foto
        self.Video = Video
        self.Testimonio = Testimonio
        self.idFinca = idFinca
        self.idTecnico = idTecnico
    }

    enum CodingKeys: String, CodingKey {
        case idProductor, Nombre, Edad, Genero, Generacion, Ubicacion
        case Latitud, Longitud, Comunidad, Foto, Video, Testimonio
        case idFinca, idTecnico
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if let id = idProductor {
            try container.encode(id, forKey: .idProductor)
        }

        try container.encode(Nombre, forKey: .Nombre)
        try container.encodeIfPresent(Edad, forKey: .Edad)
        try container.encodeIfPresent(Genero, forKey: .Genero)
        try container.encodeIfPresent(Generacion, forKey: .Generacion)
        try container.encodeIfPresent(Ubicacion, forKey: .Ubicacion)
        try container.encodeIfPresent(Latitud, forKey: .Latitud)
        try container.encodeIfPresent(Longitud, forKey: .Longitud)
        try container.encodeIfPresent(Comunidad, forKey: .Comunidad)
        try container.encodeIfPresent(Foto, forKey: .Foto)
        try container.encodeIfPresent(Video, forKey: .Video)
        try container.encodeIfPresent(Testimonio, forKey: .Testimonio)
        try container.encodeIfPresent(idFinca, forKey: .idFinca)
        try container.encodeIfPresent(idTecnico, forKey: .idTecnico)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        idProductor = try container.decodeIfPresent(Int.self, forKey: .idProductor)
        Nombre = try container.decode(String.self, forKey: .Nombre)
        Edad = try container.decodeIfPresent(Int.self, forKey: .Edad)
        Genero = try container.decodeIfPresent(String.self, forKey: .Genero)
        Generacion = try container.decodeIfPresent(String.self, forKey: .Generacion)
        Ubicacion = try container.decodeIfPresent(String.self, forKey: .Ubicacion)
        Latitud = try container.decodeIfPresent(Double.self, forKey: .Latitud)
        Longitud = try container.decodeIfPresent(Double.self, forKey: .Longitud)
        Comunidad = try container.decodeIfPresent(String.self, forKey: .Comunidad)
        Foto = try container.decodeIfPresent(String.self, forKey: .Foto)
        Video = try container.decodeIfPresent(String.self, forKey: .Video)
        Testimonio = try container.decodeIfPresent(String.self, forKey: .Testimonio)
        idFinca = try container.decodeIfPresent(Int.self, forKey: .idFinca)
        idTecnico = try container.decodeIfPresent(String.self, forKey: .idTecnico)
    }
}

extension Productor {
    var id: Int { idProductor ?? 0 }
}


