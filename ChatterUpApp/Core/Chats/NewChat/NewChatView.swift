//
//  NewChatView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 07/05/2024.
//

import SwiftUI

struct NewChatView: View {
    
    @StateObject private var viewModel = NewChatViewModel()
    @Binding var showNewChatView: Bool
    @Binding var showChatView: Bool
    @Binding var selectedChat: Chat?
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                title
                searchBar
                
                if isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        userList
                    }
                }
                
                Spacer()
            }
            .foregroundStyle(Color.theme.body)
            .padding()
        }
        .onAppear(perform: {
            Task {
                isLoading = true
                try await viewModel.getUsers()
                isLoading = false
            }
            
        })
    }
}

#Preview {
    NewChatView(showNewChatView: .constant(true), showChatView: .constant(false), selectedChat: .constant(nil))
}

extension NewChatView {
    
    private var title: some View {
        Text("New Chat")
            .font(.title2)
            .bold()
            .foregroundStyle(Color.theme.title)
    }
    
    private var searchBar: some View {
        CustomSearchBar(searchText: $viewModel.searchText, placeHolder: "Search by name...")
    }
    
    private var userList: some View {
        VStack {
            ForEach(viewModel.users, id: \.userId) { user in
                UserRowView(user: user)
                    .onTapGesture {
                        userRowOnTapGesture(user: user)
                    }
                Divider()
            }
        }
    }
    
    private func userRowOnTapGesture(user: DBUser) {
        Task {
            do {
                if let chat = try await viewModel.isChatExist(withUser: user) {
                    selectedChat = chat
                } else {
                    selectedChat = try await viewModel.createChat(withUser: user)
                }
                showNewChatView.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    showChatView.toggle()
                }
            } catch {
                print(error)
            }
        }
    }
}
