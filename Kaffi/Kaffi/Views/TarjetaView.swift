//
//  TarjetaView.swift
//  Kaffi
//
//  Created by Magda on 22/10/25.
//

import SwiftUI

struct TarjetaView: View {
    let title: String
    let subtitle: String
    let imageName: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
         
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 140)
                .frame(maxWidth: 190)
                .clipped()
            LinearGradient(
                colors: [Color.black.opacity(0.0), Color.black.opacity(0.80)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 80)
            .frame(maxWidth: 190, alignment: .bottom)
            .allowsHitTesting(false)

            // Textos
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                }
                Text(subtitle)
                    .font(.caption)
                    .opacity(0.9)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.bottom, 10)
        }
        .frame(height: 140)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}

#Preview {
    TarjetaView(title: "Test", subtitle: "Subtitle", imageName: "testGrafica")
        .padding()
}
