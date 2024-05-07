//
//  ChatsView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 06/05/2024.
//

import SwiftUI

struct ChatsView: View {
    
    @State private var searchText: String = ""
    @FocusState private var isSearchFocus: Bool
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                title
                
                VStack(spacing: 14) {
                    searchBar
                    
                    ScrollView {
                        NavigationLink {
                            Text("Chat !!")
                        } label: {
                            VStack {
                                ChatRowView(contactName: "Adi Amoyal", lastMessage: "Test message how are you today?", messageTime: "2:50 AM", newMessagesCount: 0)
                                Divider()
                            }
                        }

                        ChatRowView(contactName: "Gal Slook", lastMessage: "What are you doing tonight. I have an idea for amazing date 🥰", messageTime: "1:30 PM", newMessagesCount: 1)
                        Divider()
                        ChatRowView(contactName: "Mom", lastMessage: "Whare are you?", messageTime: "11:50 AM", newMessagesCount: 0)
                        Divider()
                        ChatRowView(contactName: "Yuval Cohen", lastMessage: "I have to talk to you, I need to tell you something", messageTime: "3:50 PM", newMessagesCount: 3)
                        Divider()
                    }
                }
                .padding(.horizontal, 2)
                
            }
            .padding()
            .foregroundStyle(Color.theme.body)
        }
    }
}

#Preview {
    NavigationStack {
        ChatsView()
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
        TextField("Search by name...", text: $searchText)
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .font(.headline)
            .focused($isSearchFocus)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(isSearchFocus ? Color.theme.primaryBlue : Color.theme.stroke ,lineWidth: 2)
            )
    }
    
}
