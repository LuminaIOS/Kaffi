

import SwiftUI

struct ConsumerHomeView: View {
    @State private var historialVisualizaciones: [HistorialItem] = [
        HistorialItem(
            nombreCafe: "Café Santa Fé",
            nombreFinca: "Finca Santa Fé",
            ubicacion: "Motozintla, Chiapas",
            fecha: "12 de Octubre, 2025"
        ),
        HistorialItem(
            nombreCafe: "Café El Mirador",
            nombreFinca: "Finca El Mirador",
            ubicacion: "San Cristóbal, Chiapas",
            fecha: "8 de Octubre, 2025"
        )
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color.lightColor1, Color.white], startPoint: .topLeading, endPoint: .bottomTrailing)

                VStack(spacing: 30) {
                    // Header
                    HStack {
                        Spacer()
                        Image("Logo")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .aspectRatio(contentMode: .fill)
                        Text("Kaffi")
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.top, 40)

                    // Headline
                    Text("Descubre el origen de tu café")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)

                    // Scan QR Button
                    NavigationLink(destination: QRScannerView()) {
                        HStack {
                            Image(systemName: "qrcode.viewfinder")
                                .font(.title2)
                            Text("Escanear código QR")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .frame(width: 300, height: 60)
                        .background(Color.midColor2)
                        .foregroundStyle(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
                    }
                    .padding(.vertical, 20)

                    // Historial de visualizaciones
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Historial de visualizaciones")
                            .font(.headline)
                            .padding(.horizontal)

                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(historialVisualizaciones) { item in
                                    NavigationLink(destination: ProductDetailsView(cafeNombre: item.nombreCafe)) {
                                        HistorialCard(item: item)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }

                    Spacer()
                }
            }
            .ignoresSafeArea()
        }
    }
}

struct HistorialItem: Identifiable {
    let id = UUID()
    let nombreCafe: String
    let nombreFinca: String
    let ubicacion: String
    let fecha: String
}

struct HistorialCard: View {
    let item: HistorialItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.nombreCafe)
                .font(.headline)
                .foregroundStyle(Color.black)

            HStack {
                Image(systemName: "map.fill")
                    .foregroundStyle(Color.darkColor1)
                    .font(.caption)
                Text(item.nombreFinca)
                    .font(.subheadline)
                    .foregroundStyle(Color.gray)
            }

            HStack {
                Image(systemName: "location.fill")
                    .foregroundStyle(Color.darkColor2)
                    .font(.caption)
                Text(item.ubicacion)
                    .font(.subheadline)
                    .foregroundStyle(Color.gray)
            }

            HStack {
                Image(systemName: "calendar")
                    .foregroundStyle(Color.midColor1)
                    .font(.caption)
                Text(item.fecha)
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ConsumerHomeView()
}
