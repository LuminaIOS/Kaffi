//
//  SearchService.swift
//  Kaffi
//
//  Created by Magda on 07/11/25.
//


import Foundation
import Supabase

struct FincaRow: Identifiable, Codable {
    let id_finca: Int
    let id_usuario: UUID
    let nombre_finca: String
    let productor: String?
    let estado: String?
    let ciudad: String?
    let descripcion: String?
    let imagen: String?
    let hectareas: Int?
    let suelo: String?
    
    var id: Int { id_finca } // para ForEach en SwiftUI
}

//busqueda
final class SearchService {
    

}
