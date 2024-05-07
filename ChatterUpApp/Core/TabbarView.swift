//
//  TabbarView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 02/05/2024.
//

import SwiftUI

@MainActor
final class TabbarViewModel: ObservableObject {
    
    @Published var currentUser: DBUser?
    
    func getCurrentUser() async throws {
        let authenticatedUser = try AuthenticationManager.shared.getAuthenticatedUser()
        self.currentUser = try await UserManager.shared.getUser(userId: authenticatedUser.uid)
    }
}

struct TabbarView: View {
    
    @StateObject private var viewmodel = TabbarViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            NavigationStack {
                ChatsView()
            }
            .tabItem {
                Image(systemName: "bubble.left.and.text.bubble.right.fill")
                Text("Chats")
            }
            
            NavigationStack {
                ProfileLoadingView(user: $viewmodel.currentUser, showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
        }
        .accentColor(.theme.primaryBlue)
        .onAppear(perform: {
            Task {
                do {
                    try await viewmodel.getCurrentUser()
                } catch {
                    
                }
            }
        })
    }
}

#Preview {
    TabbarView(showSignInView: .constant(false))
}
