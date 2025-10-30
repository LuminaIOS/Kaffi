//
//  DisplayFincasViewModel.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 23/10/25.
//
import Foundation
import SwiftData
//
//class DisplayFincasViewModel: ObservableObject {
//    @Published var fincasList: [Finca] = []
//    private var context: ModelContext
//    
//    init(context: ModelContext) {
//        self.context = context
//        fetchFincas()
//    }
//    
//    func fetchFincas() {
//        do {
//            let descriptor = FetchDescriptor<Finca>(sortBy: [SortDescriptor(\.nombre)])
//            let fetchedFincas = try context.fetch(descriptor)
//            DispatchQueue.main.async {
//                self.fincasList = fetchedFincas
//            }
//        } catch {
//            print("Error al obtener las fincas: \(error)")
//            DispatchQueue.main.async {
//                self.fincasList = []
//            }
//        }
//    }
//}
