//
//  SignInView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 26/04/2024.
//

import SwiftUI
import GoogleSignInSwift
import AuthenticationServices

struct SignInView: View {
    
    @StateObject var viewModel = SignInViewModel()
    @Binding var showSignInView: Bool
    
    // Alert
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    
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
                    
                    divider
                    
                    VStack(spacing: 15) {
                        signInWithGoogle
                        signInWithApple
                    }
                }
                .padding()
            }
            .alert(isPresented: $showAlert, content: {
                getAlert()
            })
            
        }
    }
}

#Preview {
    NavigationStack {
        SignInView(showSignInView: .constant(false))
    }
}

extension SignInView {
    
    private func getAlert() -> Alert {
        return Alert(title: Text(alertMessage))
    }
    
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
                
                forgotPassword
            }
            
            CustomActionButton(action: {
                Task {
                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                    } catch {
                        alertMessage = error.localizedDescription
                        showAlert.toggle()
                    }
                }
            }, title: "Sign In", color: .theme.primaryBlue)
        }
    }
    
    private var forgotPassword: some View {
        NavigationLink {
            ForgotPasswordView(viewModel: viewModel)
        } label: {
            Text("Forgot Password?")
                .foregroundStyle(Color.theme.body)
                .font(.subheadline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    private var divider: some View {
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
    
    private var signInWithGoogle: some View {
        GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
            Task {
                do {
                    try await viewModel.signInGoogle()
                    showSignInView = false
                } catch {
                    alertMessage = error.localizedDescription
                    showAlert.toggle()
                }
            }
        }
    }
    
    private var signInWithApple: some View {
        Button(action: {
            Task {
                do {
                    try await viewModel.signInApple()
                    showSignInView = false
                } catch {
                    alertMessage = error.localizedDescription
                    showAlert.toggle()
                }
            }
        }, label: {
            SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
                .allowsHitTesting(false)
        })
        .frame(height: 50)
    }
    
}
