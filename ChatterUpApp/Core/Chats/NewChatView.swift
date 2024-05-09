//
//  NewChatView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 07/05/2024.
//

import SwiftUI

@MainActor
final class NewChatViewModel: ObservableObject {
    
    @Published var users: [DBUser] = []
    @Published var searchText: String = ""
    
    func getUsers() async throws {
        self.users = try await UserManager.shared.getAllUsers()
    }
    
    func createChat(user: DBUser) {
        print("Create new chat with: \(user.nickname ?? "")")
        // TODO: return Chat id / Chat reference
    }
    
}

struct NewChatView: View {
    
    @StateObject private var viewModel = NewChatViewModel()
    @Binding var showNewChatView: Bool
    @Binding var showChatView: Bool
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
    NewChatView(showNewChatView: .constant(true), showChatView: .constant(false))
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
                HStack(spacing: 12) {
                    Circle()
                        .frame(width: 40, height: 40)
                    
                    VStack(alignment: .leading) {
                        Text(user.fullName ?? "")
                            .font(.headline)
                        Text(user.status?.title ?? "")
                            .font(.subheadline)
                    }
                        
                    Spacer()
                }
                .padding(.vertical, 10)
                .onTapGesture {
                    showNewChatView.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        showChatView.toggle()
                    }
                }
                Divider()
            }
        }
    }
}
