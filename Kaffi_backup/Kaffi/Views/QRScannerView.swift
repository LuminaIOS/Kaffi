

import SwiftUI
import AVFoundation

struct QRScannerView: View {
    @State private var isScanning = false
    @State private var scannedCode: String?

    var body: some View {
        ZStack {
            // Camera Preview Background (placeholder)
            Color.black.opacity(0.9)

            VStack(spacing: 30) {
                Spacer()

                // Scanner Frame
                ZStack {
                    // Scanning frame
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.midColor2, lineWidth: 4)
                        .frame(width: 280, height: 280)

                    // Corner accents
                    VStack {
                        HStack {
                            CornerBracket(rotation: 0)
                            Spacer()
                            CornerBracket(rotation: 90)
                        }
                        Spacer()
                        HStack {
                            CornerBracket(rotation: 270)
                            Spacer()
                            CornerBracket(rotation: 180)
                        }
                    }
                    .frame(width: 280, height: 280)

                    // QR Icon placeholder
                    Image(systemName: "qrcode")
                        .font(.system(size: 80))
                        .foregroundStyle(Color.lightColor1.opacity(0.5))
                }

                Spacer()

                // Instructions
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "camera.viewfinder")
                            .foregroundStyle(Color.lightColor1)
                        Text("Coloca el código QR dentro del marco")
                            .font(.headline)
                            .foregroundStyle(Color.white)
                    }

                    HStack {
                        Image(systemName: "light.max")
                            .foregroundStyle(Color.lightColor2)
                        Text("Asegúrate de tener buena iluminación")
                            .font(.subheadline)
                            .foregroundStyle(Color.white.opacity(0.8))
                    }
                }
                .padding()
                .background(Color.black.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 10))

                // Scan Button
                Button(action: {
                    // Simulate scanning
                    isScanning = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isScanning = false
                        scannedCode = "CAFE-SANTA-FE-001"
                    }
                }) {
                    HStack {
                        if isScanning {
                            ProgressView()
                                .tint(Color.white)
                            Text("Escaneando...")
                        } else {
                            Image(systemName: "qrcode.viewfinder")
                            Text("Escanear")
                        }
                    }
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .frame(width: 200, height: 50)
                    .background(isScanning ? Color.gray : Color.midColor2)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(isScanning)

                Spacer()
            }
        }
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $scannedCode) { code in
            ProductDetailsView(cafeNombre: "Café Santa Fé")
        }
    }
}

struct CornerBracket: View {
    let rotation: Double

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.midColor2)
                .frame(width: 30, height: 4)
                .offset(x: -13, y: -13)

            Rectangle()
                .fill(Color.midColor2)
                .frame(width: 4, height: 30)
                .offset(x: -13, y: -13)
        }
        .rotationEffect(.degrees(rotation))
    }
}

#Preview {
    NavigationStack {
        QRScannerView()
    }
}
