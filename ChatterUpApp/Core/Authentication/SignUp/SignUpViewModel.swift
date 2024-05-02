//
//  SignUpViewModel.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 26/04/2024.
//

import Foundation

@MainActor
final class SignUpViewModel: ObservableObject {
    
    @Published var fullName: String = ""
    @Published var nickname: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    func signUp() async throws {
        guard !validationInputs() else {
            print("Inputs are invalid")
            return
        }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    func validationInputs() -> Bool {
        if fullName.isEmpty {
            return false
        }
        
        if nickname.isEmpty {
            return false
        }
        
        if email.isEmpty {
            return false
        }
        
        if password.isEmpty {
            return false
        }
        
        if confirmPassword.isEmpty {
            return false
        }
        
        if password == confirmPassword {
            return false
        }
        
        return true
    }
}
