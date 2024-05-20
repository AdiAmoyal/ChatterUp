//
//  NewChatViewModel.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 16/05/2024.
//

import Foundation

@MainActor
final class NewChatViewModel: ObservableObject {
    
    @Published var users: [DBUser] = []
    @Published var searchText: String = ""
    
    func getUsers() async throws {
        self.users = try await UserManager.shared.getAllUsers()
    }
    
    func isChatExist(withUser: DBUser) async throws -> Chat? {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        let user = try await UserManager.shared.getUser(userId: authUser.uid)
        let (chats, _) = try await UserManager.shared.getUserChats(userId: user.userId, count: nil, lastDocument: nil)
        
        let chat = chats.first { chat in
            if chat.participents.contains(where: { $0.userId == withUser.userId }) {
                return true
            }
            return false
        }
        return chat
    }
    
    func createChat(withUser: DBUser) async throws -> Chat {
        // TODO: remove those rows of getting the user, need to save the current user in one place
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        let user = try await UserManager.shared.getUser(userId: authUser.uid)
        return try await ChatManager.shared.createNewChat(for: [user, withUser])
    }
    
}
