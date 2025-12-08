//
//
//


import SwiftUI
import PhotosUI


struct RegisterRecView: View {
    @Environment(\.dismiss) var dismiss
    @State private var vm = RecViewModel(RecordatorioService: RecordatorioService(), supabase: client)
    @State private var imageData: Data?

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Escriba su recordatorio*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Ej: Visitar la Finca Santa Fe ...", text: $vm.texto, axis: .vertical)
                            .lineLimit(4, reservesSpace: true)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .frame(height: 120)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    Button {
                        Task {
                            await vm.registrarRec()
                        }
                    } label: {
                        Text(vm.isLoading ? "Registrando..." : "Registrar Recordatorio")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(midColor1)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(vm.isLoading)
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 37)
                .padding(.top, 20)
                
            }
            .navigationTitle("Registrar Recordatorio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
            }
            
            .alert(vm.tituloAlerta, isPresented: $vm.mostrandoAlerta) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(vm.mensajeAlerta)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RegisterRecView()
}
