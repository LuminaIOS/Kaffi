//
//  LoginViewModel.swift
//  Kaffi
//
//  Created by Bernardo Torres on 28/10/25.
//

import SwiftUI
import Supabase
import Observation

@Observable
class AuthModel{
    var userEmail : String = ""
    var userPassword : String = ""
    var isLoading : Bool = false
    var authResult : Result<Void,Error>?{
        didSet{
            if case .failure = authResult{
                showAlert = true
            }
        }
    }
    var showAlert : Bool = false
    var errorMessage : String?
    
    private func toggleLoadingState(){
        withAnimation {
            isLoading.toggle()
        }
    }
    
    private func signIn() async throws{
        do{
            try await client.auth.signIn(
                email: userEmail,
                password: userPassword )
            authResult = .success(())
        }catch{
            authResult = .failure(error)
            errorMessage = error.localizedDescription
        }
            

        
    }
    
    
}
