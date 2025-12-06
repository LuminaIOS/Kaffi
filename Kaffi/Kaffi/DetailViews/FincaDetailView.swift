//
//  FincaDetailView.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 02/12/25.
//


import SwiftUI

struct FincaDetailView: View {
    @State private var vm = ProductorViewModel(productorService: ProductorService(), supabase: client)
    @State private var cvm = CosechaViewModel(cosechaService: CosechaService(), supabase: client)
    let finca: Finca
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                AsyncImage(url: URL(string: finca.imagen ?? "https://cafeab.com/files/articles/image/1683892785-granos-de-cafe.png")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipped()
                        .cornerRadius(12)
                } placeholder: {
                    Color.gray
                        .frame(height: 180)
                        .cornerRadius(12)
                }
                
                Text(finca.nombre_finca)
                    .font(.title)
                    .fontWeight(.bold)
                
                if let productor = vm.productorByID {
                    CardView {
                        SectionHeader(icon: "person.fill", title: "Productor")
                        
                        HStack(alignment: .top, spacing: 12) {
                            AsyncImage(url: URL(string: productor.Foto ?? "https://cafeab.com/files/articles/image/1683892785-granos-de-cafe.png")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 90)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } placeholder: {
                                Color.gray
                                    .frame(width: 90, height: 90)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(productor.Testimonio ?? "No hay testimonio disponible")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Divider()
                                
                                Text("Nombre: \(productor.Nombre)")
                                Text("Edad: \(productor.Edad != nil ? String(productor.Edad!) : "No disponible")")
                                Text("Género: \(productor.Genero ?? "No disponible")")
                                if let gen = productor.Generacion {
                                    Text("Agricultor de \(gen) generación")
                                }
                                Text("Ubicación: \(productor.Ubicacion ?? "No disponible")")
                                Text("Comunidad: \(productor.Comunidad ?? "No disponible")")
                            }
                        }
                    }
                }
                
                CardView {
                    SectionHeader(icon: "leaf.fill", title: "Detalles de la Finca")
                    
                    Text("Hectáreas: \(finca.hectareas)")
                    Text("Altitud: \(String(format: "%.2f", finca.altitud)) msnm")
                    Text("Variedades cultivadas: \(finca.variedades_cult)")
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Lotes activos:")
                        if let lotes = finca.lote, !lotes.isEmpty {
                            HStack {
                                ForEach(lotes, id: \.self) { lote in
                                    Text(lote)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(RoundedRectangle(cornerRadius: 6).fill(Color(.systemGray5)))
                                }
                            }
                        } else {
                            Text("No hay lotes registrados")
                                .italic()
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Text("Porte de plantas: \(finca.porte_planta)")
                }
                
                if let sombra = finca.sombra_natural,
                   let especies = finca.especies,
                   let arboles = finca.arboles_mayores {
                    CardView {
                        SectionHeader(icon: "tree.fill", title: "Sistema Agroforestal")
                        
                        Text("\(sombra)% de sombra natural")
                        Text("Especies: \(especies)")
                        Text("Árboles mayores a 8 años: \(arboles)")
                    }
                }
                if !cvm.cosechas.isEmpty {
                    CardView {
                        SectionHeader(icon: "bag.fill", title: "Cosechas Registradas")
                        
                        ForEach(cvm.cosechas) { cosecha in
                            NavigationLink(destination: CosechaDetailView(cosecha: cosecha)) {
                                CosechaMiniBox(cosecha: cosecha)
                                    .padding(.vertical, 3)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                } else {
                    Text("No hay cosechas registradas para esta finca.")
                        .foregroundColor(.secondary)
                }
                
            }
            .padding()
        }
        .task {
            if let proID = finca.id_productor {
                do {
                    try await vm.getProByID(proID)
                } catch {
                    print("Error fetching productor:", error)
                }
            }
            if let fincaID = finca.id_finca{
                do{
                    try await cvm.fetchCosechasByFinca(fincaID)
                }catch{
                    print("Error fetching cosechas:", error)
                }
            }
        }
    }
}

struct SectionHeader: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.green)
            Text(title)
                .font(.headline)
            Spacer()
        }
    }
}

struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            content
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
    }
}



#Preview {
    FincaDetailView(
        finca: Finca(
            id_finca: 42,
            id_usuario: "usuario1",
            //fecha_creacion: Date(1000000000),
            nombre_finca: "Finca Solecito",
            id_productor: 1,
            hectareas: 10,
            altitud: 1.2,
            variedades_cult: "Bourbon, Typica",
            porte_planta: "Mixto (Bajo y Alto)",
            imagen: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQP8PnhM1MNuiVPyxVkOFg45Vd1c3svVWwL8w&s",
            id_coop: 1,
            lote: ["A123", "A124", "A126"],
            sombra_natural: 10,
            especies: "Muchas",
            arboles_mayores: 0
        ),
       // productor: Productor(idProductor:1,Nombre:"Paco",Edad:67,Genero:"Masculino",Generacion:"3era",Ubicacion:"Chiapas",Latitud:12,Longitud:12,Comunidad:"algo", Foto: "https://twsylgrqwzncrqkioodg.supabase.co/storage/v1/object/public/Productor_imagenes/uploads/IMG-1F519C43-09A5-4D27-BD54-8712C37CF91E.jpg", Testimonio:"Una finca con una historia rica y larga con la que se llena un gran bloque de texto de la pantalla",idFinca:4,idTecnico:"id")
    )
}
