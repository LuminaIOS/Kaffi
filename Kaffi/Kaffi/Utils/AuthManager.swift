//
//  AuthManager.swift
//  Kaffi
//

import Foundation
import SwiftUI

@Observable
@MainActor
class AuthManager {
    static let shared = AuthManager()
    
    var currentUserID: String? = nil
    var isAuthenticated: Bool = false
    
    private init() {
        loadCurrentUser()
    }
    
    func getCurrentUserID() -> String? {
        return currentUserID
    }
    
    private func loadCurrentUser() {
        if let savedUserID = UserDefaults.standard.string(forKey: "current_user_id") {
            currentUserID = savedUserID
            isAuthenticated = true
        }
    }
    
    func loginWithID(_ userID: String) {
        currentUserID = userID
        isAuthenticated = true
        UserDefaults.standard.set(userID, forKey: "current_user_id")
    }
    
    func logout() {
        currentUserID = nil
        isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: "current_user_id")
    }
    
    func hasUser() -> Bool {
        return currentUserID != nil
    }
}
