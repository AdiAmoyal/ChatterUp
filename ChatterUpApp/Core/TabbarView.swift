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

enum Tabs: String {
    case chats, profile
    
    var title: String {
        switch self {
        case .chats:
            return "Chats"
        case .profile:
            return "Profile"
        }
    }
    
    var icon: String {
        switch self {
        case .chats:
            return "bubble.left.and.text.bubble.right.fill"
        case .profile:
            return "person.fill"
        }
    }
}

struct TabbarView: View {
    
    @StateObject private var viewmodel = TabbarViewModel()
    @Binding var showSignInView: Bool
    @State var selectedTab: Tabs = .chats
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                
                if selectedTab == .chats {
                    NavigationStack {
                        ChatsView()
                            
                    }
                } else if selectedTab == .profile {
                    NavigationStack {
                        ProfileLoadingView(user: $viewmodel.currentUser, showSignInView: $showSignInView)
                    }
                }
                
                Spacer()
                tabbar
                    .overlay {
                        VStack {
                            Button(action: {

                            }, label: {
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .bold()
                                    .frame(width: 28, height: 28)
                                    .foregroundStyle(Color.theme.background)
                            })
                            .padding()
                            .background(
                                Circle()
                                    .fill(Color.theme.seconderyBlue)
                            )
                            .padding(10)
                        }
                        .shadow(color: .theme.primaryBlue.opacity(0.7), radius: 3, x: 0.0, y: 3)
                        .background(
                            Circle()
                                .fill(Color.theme.background)
                        )
                        .position(x: 185, y: 12)
                    }
            }
        }
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

extension TabbarView {
    
    private var tabbar: some View {
        HStack {
            Spacer()
            
            CustomTabbarItem(tab: .chats, selectedTab: $selectedTab)
            
            Spacer()
            Spacer()
            Spacer()
            
            CustomTabbarItem(tab: .profile, selectedTab: $selectedTab)
            
            Spacer()
        }
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.theme.stroke)
        )
        .padding()
    }
    
}
