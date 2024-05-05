//
//  CompleteDetailsView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 04/05/2024.
//

import SwiftUI

struct CompleteDetailsView: View {
    
    @ObservedObject var viewModel: SignInViewModel
    @Binding var showSignInView: Bool
    
    // Alert
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 40) {
                title
                detailsForm
                Spacer()
            }
            .padding()
            .alert(isPresented: $showAlert, content: {
                getAlert()
            })
        }
    }
}

#Preview {
    CompleteDetailsView(viewModel: SignInViewModel(), showSignInView: .constant(false))
}

extension CompleteDetailsView {
    
    private func getAlert() -> Alert {
        return Alert(title: Text(alertMessage))
    }
    
    private var title: some View {
        Text("Just a few more details to get started")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.title)
            .padding(.top, 10)
    }
    
    private var detailsForm: some View {
        VStack(spacing: 22) {
            CustomTextField(text: $viewModel.fullName, symbol: "person", placeHolder: "Enter yout full name..", type: "Full Name")
            
            CustomTextField(text: $viewModel.nickname, symbol: "shared.with.you", placeHolder: "Enter your nickname..", type: "Nickname")
            
            CustomActionButton(action: {
                Task {
                    do {
                        try await viewModel.createUser()
                        showSignInView = false
                    } catch {
                        alertMessage = error.localizedDescription
                        showAlert = true
                    }
                }
            }, title: "Continue", color: .theme.primaryBlue)
        }
    }
}
