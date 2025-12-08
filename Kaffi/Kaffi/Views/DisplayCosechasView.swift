//
//
//
import SwiftUI

struct DisplayCosechasView: View {
    @State private var vm = CosechaViewModel(cosechaService: CosechaService(), supabase: client)
    @State private var searchText = ""
//        }
//        }
//    }
    
    var body: some View {
        ScrollView{
            VStack(){
                if vm.isLoading {
                    ProgressView("Cargando cosechas...")
                        .padding()
                } else if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(vm.cosechas) { cosecha in
                                NavigationLink(destination: CosechaDetailView(cosecha: cosecha)){
                                    CosechaBox(cosecha: cosecha)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                }
                Spacer()
            }.task {
                do{
                    await vm.fetchCosechas()
                }
                
            }
        }
    }
}

#Preview {
    DisplayCosechasView()
}
