//
//  SignUpView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 26/04/2024.
//

import SwiftUI

/*
 
 TODO: 1. Adding actions to edit photo menu
 
 */

struct SignUpView: View {
    
    @StateObject private var viewModel = SignUpViewModel()
    @Environment(\.presentationMode) var presentationMode
    @Binding var showSignInView: Bool
    
    // Alert
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    profilePicture
                    signUpForm
                    signInSection
                }
                .padding()
            }
            .alert(isPresented: $showAlert, content: {
                getAlert()
            })
        }
        .foregroundStyle(Color.theme.body)
    }
}

#Preview {
    NavigationStack {
        SignUpView(showSignInView: .constant(false))
    }
}

extension SignUpView {
    
    private func getAlert() -> Alert {
        return Alert(title: Text(alertMessage))
    }
    
    private var profilePicture: some View {
        VStack {
            Circle()
                .frame(width: 170, height: 170)
            Menu("Edit") {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "camera")
                    Text("Take Photo")
                })
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "photo")
                    Text("Choose Photo")
                })
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "trash")
                    Text("Remove Photo")
                })
            }
            .foregroundStyle(Color.theme.primaryBlue)
            .font(.headline)
        }
        
    }
    
    private var signUpForm: some View {
        VStack(spacing: 22) {
            CustomTextField(text: $viewModel.fullName, symbol: "person", placeHolder: "Enter your name..", type: "Full Name")
            
            CustomTextField(text: $viewModel.nickname, symbol: "shared.with.you", placeHolder: "Enter your nickname..", type: "Nickname")
            
            CustomTextField(text: $viewModel.email, symbol: "envelope", placeHolder: "Enter your email..", type: "Email")
            
            CustomTextField(text: $viewModel.password, symbol: "key.horizontal", placeHolder: "Enter your password", type: "Password")
            
            CustomTextField(text: $viewModel.confirmPassword, symbol: "key.horizontal", placeHolder: "Confirm your password..", type: "Password")
            
            CustomActionButton(action: {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                    } catch {
                        alertMessage = error.localizedDescription
                        showAlert = true
                    }
                }
            }, title: "Sign Up", color: .theme.primaryBlue)
        }
    }
    
    private var signInSection: some View {
        HStack {
            Text("Already have an account?")
                .foregroundStyle(Color.theme.title)
            
            Button("Sign In") {
                self.presentationMode.wrappedValue.dismiss()
            }
            .foregroundStyle(Color.theme.primaryBlue)
        }
        .bold()
    }
}
