//
//  LoginView.swift
//  Kaffi
//
//  Created by Bernardo Torres on 27/10/25.
//

import SwiftUI

struct LoginView: View {
    
    @State var email : String = ""
    @State var password : String = ""
    @State var showPassword : Bool = false
    @Bindable var vm: AuthModel
    
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(colors: [Color.lightColor1, Color.white], startPoint: .topLeading, endPoint: .bottomTrailing)
                VStack{
                    Spacer()
                    HStack{
                            Spacer()
                        Image("Logo")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                        Text("Kaffi")
                            .font(.system(size: 60))
                            .fontWeight(.light)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.bottom,100)
                    
                    
                    Form{
                        Section("\(Image(systemName: "envelope")) Correo Electrónico") {
                            TextField("Email", text: $vm.userEmail)
                                .textContentType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                            
                        }
                        
                        Section("\(Image(systemName: "key")) Contraseña"){
                            if (showPassword){
                                HStack{
                                    TextField("Contraseña", text: $vm.userPassword)
                                    
                                    
                                    Button {
                                        showPassword.toggle();
                                    } label: {
                                        Image(systemName: showPassword ? "eye.slash" : "eye")
                                            .foregroundStyle(Color.black)
                                    }
                                }
                                
                            }else{
                                HStack{
                                    SecureField("Contraseña", text: $vm.userPassword)
                                    Button {
                                        showPassword.toggle();
                                    } label: {
                                        Image(systemName: showPassword ? "eye.slash" : "eye")
                                            .foregroundStyle(Color.black)
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: 350, height: 300)
                    .scrollContentBackground(.hidden)
                    .scrollDisabled(true)
                    
                    
                    Button("Iniciar Sesión"){
                        Task{await vm.signIn()}
                    }
                    .foregroundStyle(Color.darkColor1)
                    .frame(width: 200, height: 50)
                    .background(Color.midColor2)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .disabled(vm.userEmail.isEmpty || vm.userPassword.isEmpty)
                    
                    NavigationLink(destination:SignUpView(vm: vm)){
                        Text("¿No tienes cuenta? Registrate aquí")
                    }
                    .padding(.top,10)
                    
                    Spacer()
                }
                
            }
            .ignoresSafeArea(.all)
        }
    }
}




#Preview {
    LoginView( vm: AuthModel())
}
