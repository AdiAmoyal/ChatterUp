//
//  ForgotPasswordView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 01/05/2024.
//

import SwiftUI

struct ForgotPasswordView: View {

    @ObservedObject var viewModel: SignInViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 40) {

                VStack(alignment: .leading) {
                    title
                    description
                }
                    
                CustomTextField(text: $viewModel.email, symbol: "envelope", placeHolder: "Enter your email..", type: "Email")
                
                CustomActionButton(action: {
                    Task {
                        do {
                           try await viewModel.resetPassword()
                            alertMessage = "An email with instructions to reset your password has been sent to you"
                            presentationMode.wrappedValue.dismiss()
                        } catch {
                            alertMessage = error.localizedDescription
                        }
                        showAlert.toggle()
                    }
                }, title: "Send", color: .theme.primaryBlue)
                
                Spacer()
            }
            .padding()
        }
        .alert(isPresented: $showAlert, content: {
            getAlert()
        })
    }
}

#Preview {
    ForgotPasswordView(viewModel: SignInViewModel())
}

extension ForgotPasswordView {
    
    private func getAlert() -> Alert {
        return Alert(title: Text(alertMessage))
    }
    
    private var title: some View {
            Text("Forgot Password?")
                .foregroundStyle(Color.theme.title)
                .font(.title)
                .bold()
    }
    
    private var description: some View {
        Text("Don't worry! It happens sometimes. Enter your email and we'll send you a password reset link.")
            .foregroundStyle(Color.theme.body)
            .font(.headline)
    }
    
}
