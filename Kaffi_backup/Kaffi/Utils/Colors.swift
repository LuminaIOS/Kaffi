//
//  Colors.swift
//  Kaffi
//
//  Created by Amparo Alcaraz Tonella on 21/10/25.
//

import SwiftUI

extension Color {
    static let lightColor1 = Color(red: 185/255, green: 209/255, blue: 156/255)
    static let midColor1 = Color(red: 95/255, green: 108/255, blue: 55/255)
    static let darkColor1 = Color(red: 41/255, green: 54/255, blue: 26/255)
    static let lightColor2 = Color(red: 243/255, green: 223/255, blue: 190/255)
    static let midColor2 = Color(red: 221/255, green: 160/255, blue: 95/255)
    static let darkColor2 = Color(red: 188/255, green: 108/255, blue: 39/255)
}

let lightColor1 = Color.lightColor1
let midColor1 = Color.midColor1
let darkColor1 = Color.darkColor1
let lightColor2 = Color.lightColor2
let midColor2 = Color.midColor2
let darkColor2 = Color.darkColor2

struct colorCheck: View {
    @State private var searchText = ""
    var body: some View {
        HStack(){
            Image(systemName: "star.fill")
                .foregroundStyle(lightColor1)
            Image(systemName: "star.fill")
                .foregroundStyle(midColor1)
            Image(systemName: "star.fill")
                .foregroundStyle(darkColor1)
            Image(systemName: "star.fill")
                .foregroundStyle(lightColor2)
            Image(systemName: "star.fill")
                .foregroundStyle(midColor2)
            Image(systemName: "star.fill")
                .foregroundStyle(darkColor2)
        }
        .font(.largeTitle)
    }
}
#Preview{
    colorCheck()
}
