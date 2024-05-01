//
//  SignInViewModel.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 26/04/2024.
//

import Foundation

@MainActor
final class SignInViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""

    func signIn() async throws {
        guard 
            !email.isEmpty,
            email.contains("@"),
            !password.isEmpty else {
            throw URLError(.badURL)
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
    
    func resetPassword() async throws {
        guard 
            !email.isEmpty,
            email.contains("@") else {
            throw URLError(.badURL)
        }
        print("123456")
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
}
