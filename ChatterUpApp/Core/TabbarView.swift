//
//  TabbarView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 02/05/2024.
//

import SwiftUI

struct TabbarView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        TabView {
            NavigationStack {
                // Chats View
                Text("Chats View")
            }
            .tabItem {
                Image(systemName: "bubble.left.and.text.bubble.right.fill")
                Text("Chats")
            }
            
            NavigationStack {
                ProfileView(showSignInView: $showSignInView)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
        }
        .accentColor(.theme.primaryBlue)
    }
}

#Preview {
    TabbarView(showSignInView: .constant(false))
}
