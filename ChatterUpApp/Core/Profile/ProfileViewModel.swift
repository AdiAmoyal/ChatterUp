//
//  ProfileViewModel.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 02/05/2024.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published var user: DBUser
    @Published var authProviders: [AuthProviderOption] = []
    @Published var selectedStatus: StatusOption = .available
    @Published var nickName: String = "No User"
    
    init(user: DBUser) {
        self.user = user
        self.selectedStatus = user.status ?? .available
        self.nickName = user.nickname ?? "No nickname"
        
        loadAuthProvider()
    }
    
    func loadAuthProvider() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            self.authProviders = providers
        }
    }
    
    func saveChanges() async throws {
        do {
            try await UserManager.shared.updateUserDetails(userId: user.userId, nickname: nickName, status: selectedStatus)
        } catch {
            throw error
        }
        
    }
     
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.badURL)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delet()
    }
}

enum StatusOption: String, Codable, CaseIterable {
    case available, busy, atSchool, atWork, batteryAboutToDie, cantTalk, inAMeeting, atTheGym, sleeping, urgentCallsOnly
    
    var title: String {
        switch self {
        case .available:
            "Available"
        case .busy:
            "Busy"
        case .atSchool:
            "At School"
        case .atWork:
            "At Work"
        case .batteryAboutToDie:
            "Battery About To Die"
        case .cantTalk:
            "Can't Talk"
        case .inAMeeting:
            "In A Meeting"
        case .atTheGym:
            "At The Gym"
        case .sleeping:
            "Sleeping"
        case .urgentCallsOnly:
            "Urgent Calls Only"
        }
    }
}
