

import SwiftUI
import MapKit

struct ProductDetailsView: View {
    let cafeNombre: String
    @Environment(\.dismiss) private var dismiss

    // Sample data - in production this would come from the scanned QR code
    @State private var productData = ProductData(
        nombreCafe: "Café Santa Fé",
        nombreFinca: "Finca Santa Fé",
        productor: "Gilberto García",
        ubicacion: "Motozintla, Chiapas",
        latitud: 15.3654,
        longitud: -92.2478,
        altitud: 1500,
        proceso: "Lavado",
        variedad: "Arábica Typica",
        cosecha: "Enero 2025"
    )

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 15.3654, longitude: -92.2478),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text("Detalles del producto")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(productData.nombreCafe)
                        .font(.title)
                        .fontWeight(.heavy)

                    Text(productData.nombreFinca)
                        .font(.title3)
                        .foregroundStyle(Color.darkColor1)
                }
                .padding(.horizontal)
                .padding(.top)

                // Origin Section
                VStack(alignment: .leading, spacing: 15) {
                    SectionHeader(title: "Ubicación", icon: "mappin.circle.fill")

                    VStack(alignment: .leading, spacing: 10) {
                        InfoRow(label: "Productor", value: productData.productor, icon: "person.fill")
                        InfoRow(label: "Ubicación", value: productData.ubicacion, icon: "location.fill")
                    }

                    // Map
                    Text("Mapa de la finca")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.top, 5)

                    Map(coordinateRegion: $region, annotationItems: [MapMarker(coordinate: CLLocationCoordinate2D(latitude: productData.latitud, longitude: productData.longitud))]) { marker in
                        MapPin(coordinate: marker.coordinate, tint: .midColor2)
                    }
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.horizontal)

                // Coffee Characteristics
                VStack(alignment: .leading, spacing: 15) {
                    SectionHeader(title: "Características del café", icon: "leaf.fill")

                    VStack(spacing: 12) {
                        CharacteristicCard(label: "Altitud", value: "\(productData.altitud) msnm", icon: "mountain.2.fill", color: .midColor1)
                        CharacteristicCard(label: "Proceso", value: productData.proceso, icon: "drop.fill", color: .darkColor2)
                        CharacteristicCard(label: "Variedad", value: productData.variedad, icon: "leaf.fill", color: .darkColor1)
                        CharacteristicCard(label: "Cosecha", value: productData.cosecha, icon: "calendar", color: .midColor2)
                    }
                }
                .padding(.horizontal)

                // Sustainable Practices
                VStack(alignment: .leading, spacing: 15) {
                    SectionHeader(title: "Prácticas sostenibles", icon: "heart.circle.fill")

                    VStack(alignment: .leading, spacing: 12) {
                        PracticeRow(text: "Cultivo orgánico certificado")
                        PracticeRow(text: "Sombra natural con árboles nativos")
                        PracticeRow(text: "Conservación de suelos")
                        PracticeRow(text: "Uso eficiente del agua")
                        PracticeRow(text: "Comercio justo")
                        PracticeRow(text: "Biodiversidad protegida")
                    }
                    .padding()
                    .background(Color.lightColor1.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)

                // Action Buttons
                VStack(spacing: 15) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Volver al inicio")
                            .font(.headline)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.darkColor1)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    NavigationLink(destination: QRScannerView()) {
                        Text("Escanear otro")
                            .font(.headline)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.midColor2)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
        }
        .background(Color.white.opacity(0.95))
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Supporting Views
struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(Color.midColor2)
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(Color.darkColor2)
                .frame(width: 20)
            Text(label + ":")
                .fontWeight(.semibold)
            Text(value)
                .foregroundStyle(Color.gray)
            Spacer()
        }
        .font(.subheadline)
    }
}

struct CharacteristicCard: View {
    let label: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.title3)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

struct PracticeRow: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Color.darkColor1)
                .font(.body)
            Text(text)
                .font(.subheadline)
            Spacer()
        }
    }
}

// Data Models
struct ProductData {
    let nombreCafe: String
    let nombreFinca: String
    let productor: String
    let ubicacion: String
    let latitud: Double
    let longitud: Double
    let altitud: Int
    let proceso: String
    let variedad: String
    let cosecha: String
}

struct MapMarker: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

#Preview {
    NavigationStack {
        ProductDetailsView(cafeNombre: "Café Santa Fé")
    }
}
