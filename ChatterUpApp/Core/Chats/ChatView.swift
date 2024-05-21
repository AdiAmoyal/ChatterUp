//
//  ChatView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 08/05/2024.
//

import SwiftUI
import FirebaseFirestore
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
    
    @Published var messages: [Message] = []
    @Published var newMessageText: String = ""
    @Published var chat: Chat
    @Published var currentUser: DBUser
    @Published var chatWith: DBUser?
    
    private var lastDocument: DocumentSnapshot? = nil
    private var cancellables = Set<AnyCancellable>()
    
    init(chat: Chat, currentUser: DBUser) {
        self.chat = chat
        self.currentUser = currentUser
        self.chatWith = chat.participents.first(where: { $0.userId != currentUser.userId })
    }
    
    func addListenerForMessages() {
        ChatManager.shared.addListenerForAllChatMessages(chatId: chat.id)
            .sink { complition in
                
            } receiveValue: { [weak self] messages in
                self?.messages = messages
            }
            .store(in: &cancellables)
    }
    
    func removeListenerForMessages() {
        ChatManager.shared.removeListenerForAllChatMessages()
    }
    
    func getAllMessages() async throws {
        let (newMessages, lastDocument) = try await ChatManager.shared.getAllChatMessages(chatId: chat.id, lastDocument: lastDocument)
        
        self.messages.append(contentsOf: newMessages)
        if let lastDocument {
            self.lastDocument = lastDocument
        }
    }
    
    func addNewMessage() async throws {
        // TODO: guard for validation (text is no empty)
        guard let chatWith else { return }
        try await ChatManager.shared.addNewMessage(chatId: chat.id, senderId: currentUser.userId, content: newMessageText, chatWith: chatWith.userId)
    }
}

struct LoadingChatView: View {
    
    @Binding var chat: Chat?
    @Binding var currentUser: DBUser?
    
    init(chat: Binding<Chat?>, currentUser: Binding<DBUser?>) {
        _chat = chat
        _currentUser = currentUser
    }
    
    var body: some View {
        if
            let chat = chat,
            let user = currentUser
        {
            ChatView(chat: chat, currentUser: user)
        } else {
            Text("No data")
        }
    }
}

struct ChatView: View {
    
    @StateObject private var viewModel: ChatViewModel
    @State private var scrollToMessage: String = ""
    @FocusState var isFocus: Bool
    
    init(chat: Chat, currentUser: DBUser) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(chat: chat, currentUser: currentUser))
    }
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                title
                
                ScrollView {
                    messagesList
                }
                Spacer()
                
                sendMessageSection
            }
            .foregroundStyle(Color.theme.body)
            .padding()
        }
        .onAppear(perform: {
            viewModel.addListenerForMessages()
            if let message = viewModel.chat.lastMessage {
                scrollToMessage = message.id
            }
        })
        .onDisappear(perform: viewModel.removeListenerForMessages)
    }
}

#Preview {
    NavigationStack {
        ChatView(chat: Chat(id: "1"), currentUser: DBUser(userId: "1"))
    }
}

extension ChatView {
    
    private var title: some View {
        HStack {
            Circle()
                .frame(width: 35, height: 35)
            
            Text(viewModel.chatWith?.fullName ?? "No name")
                .font(.headline)
                .foregroundStyle(Color.theme.title)
            
            Spacer()
        }
    }
    
    private var messagesList: some View {
        ScrollViewReader { proxy in
            VStack {
                if !viewModel.messages.isEmpty {
                    ForEach(viewModel.messages, id: \.self) { message in
                        ChatMessageRowView(message: message)
                            .id(message.id)
                            .background(message.senderId == viewModel.currentUser.userId ? Color.theme.primaryBlue : Color.theme.icon)
                            .cornerRadius(15)
                            .frame(maxWidth: .infinity, alignment: message.senderId == viewModel.currentUser.userId ? .trailing : .leading)
                    }
                    .onChange(of: scrollToMessage) { oldValue, newValue in
                        proxy.scrollTo(newValue)
                    }
                } else {
                    Text("No messages")
                        .font(.title2)
                        .padding(.top, 50)
                }
            }
        }
    }
    
    private var sendMessageSection: some View {
        HStack(spacing: 2) {
            TextField("Enter your message", text: $viewModel.newMessageText)
                .foregroundStyle(Color.theme.body)
                .font(.headline)
                .padding(14)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isFocus ? Color.theme.primaryBlue : Color.theme.stroke ,lineWidth: 1.5)
                )
            
            Spacer()
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.addNewMessage()
                        scrollToMessage = viewModel.messages.last?.id ?? ""
                        viewModel.newMessageText = ""
                    } catch {
                        print(error)
                    }
                }
            }, label: {
                Image(systemName: "paperplane.fill")
                    .foregroundStyle(viewModel.newMessageText.isEmpty ? Color.theme.icon : Color.theme.primaryBlue)
                    .font(.title3)
            })
        }
    }
}
