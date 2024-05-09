//
//  ChatView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 08/05/2024.
//

import SwiftUI

struct ChatView: View {
    
    @State var newMessageText: String = ""
    @State private var scrollToMessage: String = ""
    @FocusState var isFocus: Bool
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                title
                ScrollView {
                    ScrollViewReader { proxy in
                        VStack {
                            ForEach(Message.messages, id: \.self) { message in
                                ChatMessageRowView(message: message)
                                    .id(message.id)
                            }
                            .onChange(of: scrollToMessage) { oldValue, newValue in
                                proxy.scrollTo(newValue)
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
            scrollToMessage = Message.messages.last?.id ?? ""
        })
    }
}

#Preview {
    NavigationStack {
        ChatView()
    }
}

extension ChatView {
    
    private var title: some View {
        HStack {
            Circle()
                .frame(width: 35, height: 35)
            
            Text("Name")
                .font(.headline)
                .foregroundStyle(Color.theme.title)
            
            Spacer()
        }
    }
    
    
    
    private var sendMessageSection: some View {
        HStack(spacing: 2) {
            TextField("Enter your message", text: $newMessageText)
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
                Message.messages.append(Message(id: String((Int(scrollToMessage) ?? 1) + 1), senderId: "2", content: "hahahaha", isRead: true, type: .text, timeCreated: Date()))
                scrollToMessage = Message.messages.last?.id ?? ""
            }, label: {
                Image(systemName: "paperplane.fill")
                    .foregroundStyle(newMessageText.isEmpty ? Color.theme.icon : Color.theme.primaryBlue)
                    .font(.title3)
            })
        }
    }
}
