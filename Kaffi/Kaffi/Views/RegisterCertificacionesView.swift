//
//
//

import SwiftUI

struct RegisterCertificacionesView: View {
    @Environment(\.dismiss) var dismiss

    @State private var usdaOrganic: String = ""
    @State private var certimex: String = ""
    @State private var fairtrade: String = ""
    @State private var odsContribuidos: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Certificado USDA Organic (NOP)*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Sin químicos desde 2018...", text: $usdaOrganic, axis: .vertical)
                            .lineLimit(4, reservesSpace: true)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .frame(height: 120)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Certificado Certimex México Orgánico*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Certificado actualizado, clave MX-CERT-2025-0021...", text: $certimex, axis: .vertical)
                            .lineLimit(4, reservesSpace: true)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .frame(height: 120)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Certificado Fairtrade*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("Precio recibido por encima del mínimo garantizado...", text: $fairtrade, axis: .vertical)
                            .lineLimit(4, reservesSpace: true)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .frame(height: 120)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("ODS Contribuidos*")
                            .font(.body)
                            .foregroundColor(.black)
                        TextField("1, 5, 6", text: $odsContribuidos)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }

                    Button {
                        print("Registrando...")
                    } label: {
                        Text("Registrar")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.midColor1)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                }
                .padding(.horizontal, 37)
                .padding(.top, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    RegisterCertificacionesView()
}

