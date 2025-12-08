//
//
//
//

import SwiftUI

struct TabBarView: View {
    @State private var searchText = ""
    @Bindable var vm: AuthModel
    
    var body: some View {
        TabView {
//            }
            
            NavigationStack {
                DisplayFincasView()
                    .navigationTitle("Fincas").toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(darkColor2, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Fincas", systemImage: "map.fill") }
            NavigationStack {
                ScrollBarView()
                    .navigationTitle("Registros").toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(darkColor2, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Registros", systemImage: "plus.app.fill") }
            
            NavigationStack {
                DisplayCosechasView()
                    .navigationTitle("Cosechas").toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(darkColor2, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Cosechas", systemImage: "leaf.fill") }
             
            NavigationStack {
                TPerfilView()
                    .navigationTitle("Perfil").toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(darkColor2, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem { Label("Perfil", systemImage: "person") }
        }
        .tabViewStyle(.automatic)
        .tint(midColor1)
    }
}

struct TPerfilView: View {
    @State private var searchText = ""
    @State private var isEditing = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.lightColor1.opacity(0.3))
                            .frame(width: 120, height: 120)

                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(Color.darkColor1.opacity(0.7))
                    }

                    Text("Don José García")
                        .font(.title2)
                        .bold()

                    Text("@joseg_cafe")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                .padding(.top, 20)

                VStack(spacing: 0) {
                    ProfileInfoRow(title: "Nombre completo", value: "Don José García")
                    Divider().padding(.leading, 16)
                    ProfileInfoRow(title: "Usuario", value: "@joseg_cafe")
                    Divider().padding(.leading, 16)
                    ProfileInfoRow(title: "Cooperativa", value: "Café Orgánico de Chiapas")
                    Divider().padding(.leading, 16)
                    ProfileInfoRow(title: "Rol", value: "Productor")
                    Divider().padding(.leading, 16)
                    ProfileInfoRow(title: "Fecha de nacimiento", value: "15 de marzo de 1967")
                }
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal)

                VStack(spacing: 12) {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "person.fill")
                            Text("Editar Perfil")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                    }
                    .foregroundColor(.primary)

                    Button(action: {}) {
                        HStack {
                            Image(systemName: "gearshape.fill")
                            Text("Configuración")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                    }
                    .foregroundColor(.primary)

                    Button(action: {}) {
                        HStack {
                            Image(systemName: "arrow.right.square.fill")
                            Text("Cerrar sesión")
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                    }
                    .foregroundColor(.red)
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct ProfileInfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
        .padding()
    }
}
#Preview {
    TabBarView(vm: AuthModel())
}
