//
//  LoteDetailViewModel.swift
//  Kaffi
//

import Foundation
import SwiftUI
import Observation

@Observable
class LoteDetailViewModel {
    var loteDetail: LoteDetail?
    var isLoading = false
    var errorMessage: String?
    private let service = LoteDetailService()
    
    @MainActor
    func cargarDetalles(lote: Lote) async {
        guard let id_lote = lote.id_lote else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            loteDetail = try await service.fetchLoteDetail(id_lote: id_lote)
        } catch {
            errorMessage = "Error al cargar los detalles: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
