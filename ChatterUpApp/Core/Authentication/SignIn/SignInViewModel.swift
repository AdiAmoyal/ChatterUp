//
//  SignInViewModel.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 26/04/2024.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import UIKit

@MainActor
final class SignInViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    func signIn() async throws {
        guard
            !email.isEmpty,
            email.contains("@") else {
            throw SignInError.invalidEmail
        }
        
        guard
            !password.isEmpty else {
            throw SignInError.invalidPassword
        }
        
        do {
            try await AuthenticationManager.shared.signInUser(email: email, password: password)
        } catch {
            throw SignInError.noUserFound
        }
    }
    
    func resetPassword() async throws {
        guard
            !email.isEmpty,
            email.contains("@") else {
            throw SignInError.invalidEmail
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let signInGoogleResult = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(googleResultModel: signInGoogleResult)
    }
    
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let signInAppleResult = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(appleResultModel: signInAppleResult)
    }
}

enum SignInError: LocalizedError {
    case invalidEmail
    case invalidPassword
    case mismatchedPasswords
    case noUserFound
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Invalid email address"
        case .invalidPassword:
            return "Invalid Password"
        case .mismatchedPasswords:
            return "Mismatched passwords"
        case .noUserFound:
            return "No user found for this email address"
        }
    }
}
