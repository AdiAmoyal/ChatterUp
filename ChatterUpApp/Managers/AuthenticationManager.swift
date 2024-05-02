//
//  AuthenticationManager.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 26/04/2024.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
    case apple = "apple.com"
}

private enum AuthenticationError: LocalizedError {
    case noUser
    
    var errorDescription: String? {
        switch self {
        case .noUser:
            return "There is no logged in user."
        }
    }
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init () { }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw AuthenticationError.noUser
        }
        return AuthDataResultModel(user: user)
    }
    
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badURL)
        }
        
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
        }
        
        return providers
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
}

// MARK: Sing In Email

extension AuthenticationManager {
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataRusult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataRusult.user)
    }
    
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataRusult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataRusult.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthenticationError.noUser
        }
        try await user.updatePassword(to: password)
    }
}

// MARK: Sing In SSO

extension AuthenticationManager {
    
    func signInWithGoogle(googleResultModel: SignInWithGoogleResult) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: googleResultModel.idToken, accessToken: googleResultModel.accessToken)
        return try await signIn(credential: credential)
    }
    
    func signInWithApple(appleResultModel: SignInWithAppleResult) async throws -> AuthDataResultModel {
        let credential = OAuthProvider.appleCredential(withIDToken: appleResultModel.token,
                                                       rawNonce: appleResultModel.nonce,
                                                       fullName: nil)
        return try await signIn(credential: credential)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}
