//
//  ChatView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 08/05/2024.
//

import SwiftUI

@MainActor
final class ChatViewModel: ObservableObject {
    
    @Published var newMessageText: String = ""
    @Published var chat: Chat
    @Published var currentUser: DBUser
    @Published var chatWith: [DBUser]
    
    init(chat: Chat, currentUser: DBUser) {
        self.chat = chat
        self.currentUser = currentUser
        self.chatWith = chat.participents?.filter({ $0.userId != currentUser.userId }) ?? []
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
                    ScrollViewReader { proxy in
                        VStack {
                            if let messages = viewModel.chat.messages,
                               !messages.isEmpty {
                                ForEach(messages, id: \.self) { message in
                                    ChatMessageRowView(message: message)
                                        .id(message.id)
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
                Spacer()
                
                sendMessageSection
            }
            .foregroundStyle(Color.theme.body)
            .padding()
        }
        .onAppear(perform: {
            if let message = viewModel.chat.lastMessage {
                scrollToMessage = message.id
            }
        })
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
            
            Text(viewModel.chatWith.first?.fullName ?? "No name")
                .font(.headline)
                .foregroundStyle(Color.theme.title)
            
            Spacer()
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
                // TODO: Create function in viewModel
                scrollToMessage = Message.messages.last?.id ?? ""
            }, label: {
                Image(systemName: "paperplane.fill")
                    .foregroundStyle(viewModel.newMessageText.isEmpty ? Color.theme.icon : Color.theme.primaryBlue)
                    .font(.title3)
            })
        }
    }
}
