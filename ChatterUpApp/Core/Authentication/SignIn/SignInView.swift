//
//  SignInView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 26/04/2024.
//

import SwiftUI

struct SignInView: View {
    
    @StateObject var viewModel = SignInViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 40) {
                    Text("")
                        .frame(height: 170)
                    
                    VStack(spacing: 8) {
                        header
                        signUpSection
                    }
                    
                    signInWithEmail
//                        .padding(.top, 20)
                    
                    Divider()
                        .foregroundColor(Color.theme.stroke)
                        .overlay {
                            Text("or sign in with")
                                .foregroundStyle(Color.theme.body)
                                .bold()
                                .padding(8)
                                .background(Color.theme.background)
                                .offset(y: -1)
                        }
                    
                    
                }
                .padding()
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignInView(showSignInView: .constant(false))
    }
}

extension SignInView {
    
    private var header: some View {
        Text("Sign In to ChetterUp")
            .foregroundStyle(Color.theme.title)
            .font(.title)
            .bold()
    }
    
    private var signUpSection: some View {
        HStack {
            Text("Don't have an account?")
                .foregroundStyle(Color.theme.body)
            
            NavigationLink("Sign Up") {
                SignUpView(showSignInView: $showSignInView)
            }
            .foregroundStyle(Color.theme.primaryBlue)
            .bold()
        }
        .font(.headline)
    }
    
    private var signInWithEmail: some View {
        VStack(spacing: 25) {
            CustomTextField(text: $viewModel.email, symbol: "envelope", placeHolder: "Enter your email..", type: "Email")
            
            VStack(spacing: 5) {
                CustomTextField(text: $viewModel.password, symbol: "key.horizontal", placeHolder: "Enter your password..", type: "Password")
                
                Text("Forgot Password?")
                    .foregroundStyle(Color.theme.body)
                    .font(.subheadline)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
    
            Button(action: {
                Task {
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                    } catch {
                        print("Cannot Sign In!")
                    }
                }
            }, label: {
                Text("Sign In")
                    .foregroundStyle(Color.white)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.theme.primaryBlue)
                    )
            })
        }
    }
    
}
