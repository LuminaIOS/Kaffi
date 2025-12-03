//
//  ProduccionView.swift
//  Trial
//
//  Created by Angela Rodriguez on 25/11/25.
//

import SwiftUI

struct RegisterProduccionView: View {
    @State private var practicas: [String] = []
    @State private var nuevaPractica: String = ""
    @State private var manejoPlagas: [String] = []
    @State private var NuevoManejoPlagas: String = ""
    @State private var Riego: String = ""
    @State private var mostrarListaCertificaciones = false

    @State private var certificacionesSeleccionadas: [String] = []

    @State private var certificacionesDisponibles: [String] = [
        "USDA Organic (NOP) – Certimex, vigente 2025",
        "Certificado LPO – México Orgánico",
        "Fairtrade International – FLO ID 57893",
        "En transición a Carbono Neutral (ISO 14064)",
        "Otro"
    ]

    @State private var textoCertificacionOtra: String = ""

    
    var body: some View {
        ScrollView{
            
            // Manejo de suelos
            VStack(alignment: .leading, spacing: 4) {
                Text("Manejo de suelos*")
                    .font(.body)
                    .foregroundColor(.black)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(practicas, id: \.self) { p in
                        Text(p)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .foregroundColor(.black)
                    }
                }
                
                HStack {
                    TextField("Agregar práctica...", text: $nuevaPractica)
                        .foregroundColor(.black)
                    
                    Button {
                        if !nuevaPractica.isEmpty {
                            practicas.append(nuevaPractica)
                            nuevaPractica = ""
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.midColor1)
                            .font(.system(size: 22))
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Control de plagas*")
                    .font(.body)
                    .foregroundColor(.black)
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(manejoPlagas, id: \.self) { p in
                        Text(p)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .foregroundColor(.black)
                    }
                }
                
                HStack {
                    TextField("Agregar práctica...", text: $NuevoManejoPlagas)
                        .foregroundColor(.black)
                    
                    Button {
                        if !NuevoManejoPlagas.isEmpty {
                            manejoPlagas.append(NuevoManejoPlagas)
                            NuevoManejoPlagas = ""
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.midColor1)
                            .font(.system(size: 22))
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Riego*")
                    .font(.body)
                    .foregroundColor(.black)
                TextField("No usa riego", text: $Riego)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Certificaciones*")
                    .font(.body)
                    .foregroundColor(.black)

                Button {
                    withAnimation {
                        mostrarListaCertificaciones.toggle()
                    }
                } label: {
                    HStack {
                        Text(
                            certificacionesSeleccionadas.isEmpty
                            ? "Selecciona certificaciones"
                            : certificacionesSeleccionadas.joined(separator: ", ")
                        )
                        .foregroundColor(certificacionesSeleccionadas.isEmpty ? .gray : .black)
                        
                        Spacer()
                        Image(systemName: mostrarListaCertificaciones ? "chevron.up" : "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }

                if mostrarListaCertificaciones {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(certificacionesDisponibles, id: \.self) { c in
                            Button {
                                if certificacionesSeleccionadas.contains(c) {
                                    certificacionesSeleccionadas.removeAll { $0 == c }

                                    
                                    if c == "Otro" {
                                        textoCertificacionOtra = ""
                                    }

                                } else {
                                    certificacionesSeleccionadas.append(c)
                                }
                            } label: {
                                HStack {
                                    Image(systemName: certificacionesSeleccionadas.contains(c) ?
                                          "checkmark.square.fill" : "square")
                                        .foregroundColor(.lightColor1)
                                    ScrollView(.horizontal, showsIndicators: false){
                                        Text(c)
                                            .font(.system(size: 17))
                                            .lineLimit(1)
                                            .foregroundColor(.black)
                                    }
                                    Spacer()
                                }
                            }

                           
                            if c == "Otro",
                               certificacionesSeleccionadas.contains("Otro") {

                                TextField("Especifica certificación...", text: $textoCertificacionOtra)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .transition(.opacity)
                    .zIndex(10)
                }
            }
            
            .padding(.vertical)
            
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

    

#Preview {
    RegisterProduccionView()
}
