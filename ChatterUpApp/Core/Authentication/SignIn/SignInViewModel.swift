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
        guard !email.isEmpty, !password.isEmpty else {
            print("Inputs are invalid")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}
