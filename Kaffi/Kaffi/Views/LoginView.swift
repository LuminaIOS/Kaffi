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
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(colors: [Color.lightColor1, Color.white], startPoint: .topLeading, endPoint: .bottomTrailing)
                VStack{
                    Spacer()
                    HStack{
                        Image("Logo")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                        Text("Kaffi")
                            .font(.system(size: 35, weight: .semibold, design: .default))
                            .fontWeight(.bold)
                    }
                    .padding(.bottom,100)
                    
                    
                    Form{
                        Section("\(Image(systemName: "mail")) Correo Electrónico") {
                            TextField("Email", text: $email)
                                .textContentType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                            
                        }
                        
                        Section("\(Image(systemName: "key")) Contraseña"){
                            if (showPassword){
                                HStack{
                                    TextField("Contraseña", text: $password)
                                    
                                    
                                    Button {
                                        showPassword.toggle();
                                    } label: {
                                        Image(systemName: showPassword ? "eye.slash" : "eye")
                                            .foregroundStyle(Color.black)
                                    }
                                }
                                
                            }else{
                                HStack{
                                    SecureField("Contraseña", text: $password)
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
                        
                    }
                    .foregroundStyle(Color.darkColor1)
                    .frame(width: 200, height: 50)
                    .background(Color.lightColor1)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .disabled(email.isEmpty || password.isEmpty)
                    
                    NavigationLink(destination:SignUpView()){
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
    LoginView()
}


struct SignUpView: View {
    var body: some View{
        Text("...")
    }
}

