//
//  FincaDetailView.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 02/12/25.
//


import SwiftUI
struct FincaDetailView: View {
    @State private var vm = ProductorViewModel(productorService: ProductorService(), supabase: client)
    let finca: Finca
    //let productor: Productor
    var body: some View {
        VStack{
            HStack(){
                AsyncImage(url: URL(string: finca.imagen ?? "https://cafeab.com/files/articles/image/1683892785-granos-de-cafe.png")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                } placeholder: {
                    Color.gray
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                }
            }
            VStack {
                Text(finca.nombre_finca)
                    .font(.title2)
                    .font(.headline)
            }
            
            VStack(spacing: 4) {
                if let productor = vm.productorByID{
                    VStack(alignment: .leading){
                        HStack{
                            Image(systemName:"star.fill")
                                .foregroundColor(.yellow)
                            Text("Sobre el productor")
                                .font(.headline)
                            Spacer()
                        }
                        
                        VStack(alignment: .leading){
                            HStack(){
                                Text("\(productor.Testimonio ?? "No hay testimonio disponible")")
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Spacer()
                                AsyncImage(url: URL(string: productor.Foto ?? "https://cafeab.com/files/articles/image/1683892785-granos-de-cafe.png")) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                } placeholder: {
                                    Color.gray
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                }
                                
                                .padding(.horizontal, 5)
                                .padding(.vertical,10)
                            }
                            Text("Nombre del productor: \(productor.Nombre)")
                            Text("Edad: \(productor.Edad != nil ? String(productor.Edad!) : "Edad no disponible")")
                            Text("Género: \(productor.Genero ?? "Género no disponible")")
                            if let gen = productor.Generacion {
                                Text("Agricultor de \(gen) generación")
                            }
                            Text("Ubicacion: \(productor.Ubicacion ?? "Ubicacion no disponible")")
                            Text("Comunidad: \(productor.Comunidad ?? "Comunidad no disponible")")
                            
                            
                        }
                        .padding(.horizontal, 15)
                        
                    }
                }
                Text(" ")
                VStack(alignment: .leading){
                    HStack{
                        Image(systemName:"star.fill")
                            .foregroundColor(.yellow)
                        Text("Sobre la Finca")
                            .font(.headline)
                        Spacer()
                    }
                    VStack(alignment: .leading){
                        Text("Hectareas: \(finca.hectareas)")
                        Text("Altitud: \(String(format: "%.2f", finca.altitud)) metros sobre el nivel del mar")
                        
//                        if let lat = productor.Latitud,
//                           let lon = productor.Longitud{
//                            Text("coordenadas: \(lat) y \(lon)")
//                            Text("MAPA AQUI")
//                        }
                        Text("Variedades cultivadas:  \(finca.variedades_cult)")
                        Text("Lotes: ")
                        if let lotes = finca.lote, !lotes.isEmpty {
                            ForEach(lotes, id: \.self) { lote in
                                Text(" - \(lote)")
                            }
                        } else {
                            Text("No hay lotes registrados")
                                .italic()
                                .foregroundColor(.gray)
                        }
                        Text("Porte de plantas: \(finca.porte_planta)")
                    }
                    .padding(.horizontal, 15)
                    
                    Text(" ")
                    if let som = finca.sombra_natural,
                       let esp = finca.especies,
                       let may = finca.arboles_mayores{
                        VStack(alignment: .leading){
                            HStack{
                                Image(systemName:"leaf.fill")
                                    .foregroundColor(.green)
                                Text("Sistema Agroforestal")
                                    .font(.headline)
                                Spacer()
                            }
                            Text("\(som)% de sombra natural")
                            Text("Especies: \(esp)")
                            Text("Arboles sombra mayores a 8 años \(may)")
                        }
                        
                        .padding(.horizontal, 15)
                    }
                }
                
                
            }
            .padding(5)
            
        }
        .padding()
        Spacer()
            .task {
                if let proID = finca.id_productor {
                    do{
                        try await vm.getProByID(proID)
                    }catch{
                        print("Error fetching productor:", error)
                    }
                }
            }
    }
}

#Preview {
    FincaDetailView(
        finca: Finca(
            id_finca: 1,
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
