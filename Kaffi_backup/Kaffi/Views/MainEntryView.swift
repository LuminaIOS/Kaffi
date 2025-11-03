
import SwiftUI

struct MainEntryView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color.lightColor1, Color.white], startPoint: .topLeading, endPoint: .bottomTrailing)

                VStack(spacing: 40) {
                    Spacer()

                    // App Logo and Name
                    HStack {
                        Spacer()
                        Image("Logo")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .aspectRatio(contentMode: .fill)
                        Text("Kaffi")
                            .font(.system(size: 70))
                            .fontWeight(.bold)
                        Spacer()
                    }

                    // Headline question
                    Text("¿De dónde viene tu café?")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)

                    Spacer()

                    // Primary Action - Scan QR
                    Button(action: {
                        // Navigate to QR Scanner
                    }) {
                        HStack {
                            Image(systemName: "qrcode.viewfinder")
                                .font(.title2)
                            Text("Escanear QR")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .frame(width: 280, height: 60)
                        .background(Color.midColor2)
                        .foregroundStyle(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    }

                    Spacer()

                    // Secondary Actions
                    VStack(spacing: 20) {
                        NavigationLink(destination: LoginView()) {
                            Text("Iniciar Sesión")
                                .font(.headline)
                                .frame(width: 280, height: 50)
                                .background(Color.darkColor1)
                                .foregroundStyle(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }

                        NavigationLink(destination: SignUpView()) {
                            Text("¿No tienes cuenta? Regístrate aquí")
                                .font(.subheadline)
                                .foregroundStyle(Color.darkColor2)
                        }
                    }

                    Spacer()
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    MainEntryView()
}
