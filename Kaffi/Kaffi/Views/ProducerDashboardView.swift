

import SwiftUI
import SwiftData

struct ProducerDashboardView: View {
    @State private var searchText: String = ""
    @Query var fincas: [Finca]
    @Query var lotes: [Lote]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Greeting
                    Text("Bienvenido Gilberto")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top, 20)

                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color.gray)
                        TextField("Buscar lote o finca", text: $searchText)
                            .textInputAutocapitalization(.never)
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)

                    // Reminder Card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(Color.white)
                            Text("Recordatorio")
                                .font(.headline)
                                .foregroundStyle(Color.white)
                        }

                        Text("Falta llenar información sobre Lote 5")
                            .font(.subheadline)
                            .foregroundStyle(Color.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.darkColor2)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)

                    // Statistics Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Estadística 1")
                            .font(.headline)
                            .padding(.bottom, 5)

                        // Simple bar chart visualization
                        HStack(alignment: .bottom, spacing: 12) {
                            ForEach(0..<7) { index in
                                VStack {
                                    Rectangle()
                                        .fill(Color.midColor1)
                                        .frame(width: 30, height: CGFloat.random(in: 50...150))

                                    Text("L\(index + 1)")
                                        .font(.caption2)
                                        .foregroundStyle(Color.gray)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)

                    // Quick Summary Cards
                    HStack(spacing: 15) {
                        // Fincas Summary
                        VStack(spacing: 10) {
                            Image(systemName: "map.fill")
                                .font(.largeTitle)
                                .foregroundStyle(Color.darkColor1)

                            Text("Tus Fincas")
                                .font(.headline)

                            Text("\(fincas.count) registradas")
                                .font(.subheadline)
                                .foregroundStyle(Color.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.lightColor2)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

                        // Lotes Summary
                        VStack(spacing: 10) {
                            Image(systemName: "mappin")
                                .font(.largeTitle)
                                .foregroundStyle(Color.darkColor1)

                            Text("Tus Lotes")
                                .font(.headline)

                            Text("\(lotes.count) registrados")
                                .font(.subheadline)
                                .foregroundStyle(Color.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.lightColor1)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .background(Color.white.opacity(0.95))
        }
    }
}

#Preview {
    ProducerDashboardView()
        .modelContainer(for: [Finca.self, Lote.self])
}
