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
@MainActor

final class AuthModel{
    var userEmail : String = ""
    var userPassword : String = ""
    var errorMessage : String?
    
    func signUp(){
        
    }
}
