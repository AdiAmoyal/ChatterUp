//
//  RootView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 26/04/2024.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack {
            if !showSignInView {
                TabbarView(showSignInView: $showSignInView)
            }
        }
        .onAppear(perform: {
            // TODO: Save auth user
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        })
        .fullScreenCover(isPresented: $showSignInView, content: {
            NavigationStack {
                SignInView(showSignInView: $showSignInView)
            }
        })
    }
}

#Preview {
    RootView()
}
