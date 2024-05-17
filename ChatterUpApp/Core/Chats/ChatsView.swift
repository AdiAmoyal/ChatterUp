//
//  ChatsView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 06/05/2024.
//

import SwiftUI

@MainActor
final class ChatsViewModel: ObservableObject {
    
    @Published var chats: [Chat] = []
    @Published var searchText: String = ""
    @Published var user: DBUser
    
    init(user: DBUser) {
        self.user = user
    }
    
    func getAllChats() async throws {
        self.chats = try await UserManager.shared.getUserChats(userId: user.userId)
        
    }
}

struct LoadingChatsView: View {
    
    @Binding var user: DBUser?
    
    init(user: Binding<DBUser?>) {
        _user = user
    }
    
    var body: some View {
        if let user = user {
            ChatsView(user: user)
        }
    }
}

struct ChatsView: View {

    @StateObject private var viewModel: ChatsViewModel
    @FocusState private var isSearchFocus: Bool
    
    init(user: DBUser) {
        _viewModel = StateObject(wrappedValue: ChatsViewModel(user: user))
    }
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                title
                
                VStack(spacing: 14) {
                    searchBar
                    
                    if !viewModel.chats.isEmpty {
                        chatsList
                    } else {
                        noChatsView
                    }
                }
                .padding(.horizontal, 2)
                
                Spacer()
            }
            .padding()
            .foregroundStyle(Color.theme.body)
        }
        .task {
            do {
                try await viewModel.getAllChats()
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatsView(user: DBUser(userId: "1"))
    }
}

extension ChatsView {
    
    private var title: some View {
        HStack {
            Text("Chats")
                .foregroundStyle(Color.theme.title)
                .font(.title)
                .bold()
            
            Spacer()
        }
    }

    private var searchBar: some View {
        CustomSearchBar(searchText: $viewModel.searchText, placeHolder: "Search by name...")
    }
    
    private var chatsList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.chats) { chat in
                    if let chatWith = chat.participents?.filter( { $0.userId != viewModel.user.userId }).first,
                       let lastMessage = chat.lastMessage {
                        NavigationLink {
                            ChatView(chat: chat, currentUser: viewModel.user)
                        } label: {
                            ChatRowView(chatWith: chatWith, lastMessage: lastMessage, newMessagesCount: 0)
                        }
                        
                        Divider()
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var noChatsView: some View {
        Text("No Chats yet")
            .font(.title2)
            .bold()
            .padding(.top, 50)
    }
}
