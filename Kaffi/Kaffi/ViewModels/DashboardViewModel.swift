//
//
//

import SwiftUI
import Combine

class DashboardViewModel: ObservableObject {
    
    @Published var nombre: String = "Magda"
    @Published var textoBusqueda: String = ""
    @Published var numFincas: Int = 0
    @Published var numLotes: Int = 0
    @Published var Imagen: Image = Image("grafica")
    @State var searchText = ""
    
    enum Destino { case fincas, lotes, settings }
    var onNavigate: ((Destino) -> Void)?
    
    private let service: DashboardService
    init(service: DashboardService = PruebaDashboardService())
    {
        self.service = service
        Task { await cargar() }
    }
    
    @MainActor
    func cargar() async {
        
        let resumen = await service.fetchResumen()
        numFincas = resumen.fincas
        numLotes = resumen.lotes
    }
    
    func TapFincas() { onNavigate?(.fincas) }
    func TapLotes() { onNavigate?(.lotes) }
}
