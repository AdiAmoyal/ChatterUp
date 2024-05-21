//
//  ChatsView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 06/05/2024.
//

import SwiftUI
import FirebaseFirestore
import Combine

@MainActor
final class ChatsViewModel: ObservableObject {
    
    @Published var chats: [Chat] = []
    @Published var searchText: String = ""
    @Published var user: DBUser
    private var lastDocument: DocumentSnapshot? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init(user: DBUser) {
        self.user = user
    }
    
    func addListenerForChats() {
        UserManager.shared.addListenerForAllUserChats(userId: user.userId)
            .sink { complition in
                
            } receiveValue: { [weak self] chats in
                self?.chats = chats
            }
            .store(in: &cancellables)
    }
    
    func getAllChats() async throws {
        let (newChats, lastDocument) = try await UserManager.shared.getUserChats(userId: user.userId, count: 12, lastDocument: lastDocument)
        self.chats.append(contentsOf: newChats)
        if let lastDocument {
            self.lastDocument = lastDocument
        }
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
    @State private var didApear: Bool = false
    
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
        .onFirstAppear {
            Task {
                do {
                    viewModel.addListenerForChats()
                } catch {
                    print(error)
                }
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
            VStack {
                ForEach(viewModel.chats) { chat in
                    if let chatWith = chat.participents.first(where: { $0.userId != viewModel.user.userId }) {
                        NavigationLink {
                            ChatView(chat: chat, currentUser: viewModel.user)
                        } label: {
                            ChatRowView(chatWith: chatWith, lastMessage: chat.lastMessage, newMessagesCount: 0)
                        }
                        
                        Divider()
                        
                        if viewModel.chats.count > 7 && chat == viewModel.chats.last {
                            ProgressView()
                                .onAppear(perform: {
                                    Task {
                                        try await viewModel.getAllChats()
                                    }
                                })
                        }
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
