//
//  Dashboard.swift
//  Kaffi
//
//  Created by Magda on 21/10/25.
//

protocol DashboardService {
    
    func fetchResumen() async -> (fincas: Int, lotes: Int)
}

struct PruebaDashboardService: DashboardService {
    func fetchResumen() async -> (fincas: Int, lotes: Int) {
        (fincas: 5, lotes: 15)
    }
}
