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
    // TODO: Profile picture
    
    func signUp() async throws {
        guard !validationInputs() else {
            throw SignInError.invalidInputs
        }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        let user = DBUser(auth: authDataResult, fullName: fullName, nickname: nickname)
        try await UserManager.shared.createNewUser(user: user)
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
