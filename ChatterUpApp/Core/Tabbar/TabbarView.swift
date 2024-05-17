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
    case chats, profile, plus
    
    var title: String {
        switch self {
        case .chats:
            return "Chats"
        case .profile:
            return "Profile"
        case .plus:
            return ""
        }
    }
    
    var icon: String {
        switch self {
        case .chats:
            return "bubble.left.and.text.bubble.right.fill"
        case .profile:
            return "person.fill"
        case .plus:
            return "plus"
        }
    }
}

struct TabbarView: View {
    
    @StateObject private var viewmodel = TabbarViewModel()
    @Binding var showSignInView: Bool
    
    @State var selectedTab: Tabs = .chats
    @State var showNewChatView: Bool = false
    @State var showChatView: Bool = false
    @State var selectedChat: Chat? = nil
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            GeometryReader(content: { geometry in
                VStack {
                    switch selectedTab {
                    case .chats, .plus:
                        NavigationStack {
                            LoadingChatsView(user: $viewmodel.currentUser)
                        }
                    case .profile:
                        NavigationStack {
                            ProfileLoadingView(user: $viewmodel.currentUser, showSignInView: $showSignInView)
                        }
                    }
                    
                    tabbar
                        .overlay {
                            CustomTabbarItem(tab: .plus, selectedTab: $selectedTab, showNewChatView: $showNewChatView)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 30)
                        }
                }
                .sheet(isPresented: $showNewChatView, content: {
                    NewChatView(showNewChatView: $showNewChatView, showChatView: $showChatView, selectedChat: $selectedChat)
                })
                .background(
                    NavigationLink(
                        destination: LoadingChatView(chat: $selectedChat, currentUser: $viewmodel.currentUser),
                        isActive: $showChatView,
                        label: {
                            EmptyView()
                        })
                )
                
                
            })
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
            
            CustomTabbarItem(tab: .chats, selectedTab: $selectedTab, showNewChatView: $showNewChatView)
            
            Spacer()
            Spacer()
            Spacer()
            
            CustomTabbarItem(tab: .profile, selectedTab: $selectedTab, showNewChatView: $showNewChatView)
            
            Spacer()
        }
        .frame(height: 65)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.theme.stroke)
        )
        .padding()
    }
    
}
