//
//  ProfileView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 02/05/2024.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    @State private var nickName: String = "Nick Name"
    @State private var showAlert: Bool = false
    
    // Alert
    @State private var showDeleteAccountAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertType: String = ""
    
    var body: some View {
        ZStack {
            
            Color.theme.background
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                VStack(spacing: 18) {
                    profilePicture
                    profileDetails
                }
                
                VStack(spacing: 18) {
                    CustomTextField(text: $nickName, symbol: "shared.with.you", placeHolder: nickName, type: "Nickname")
                    
                    statusPicker
                }
                
                Spacer()
                
                buttonsSection
                
            }
            .foregroundStyle(Color.theme.body)
            .padding()
        }
        .alert(isPresented: $showAlert, content: {
            getAlert(type: alertType)
        })
        .onAppear(perform: {
            viewModel.loadAuthProvider()
        })
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}

extension ProfileView {
    
    private func getAlert(type: String) -> Alert {
        if type == "delete" {
            return getDeleteAccountAlert()
        }
        return Alert(title: Text(alertMessage))
    }
    
    private func getDeleteAccountAlert() -> Alert {
        return Alert(
            title: Text(""),
            message: Text(alertMessage),
            primaryButton: .cancel(),
            secondaryButton: .destructive(
                Text("Delete"),
                action: {
                    Task {
                        do {
                            try await viewModel.deleteAccount()
                            showSignInView = true
                        } catch {
                            alertMessage = "Please log in again before retrying this request"
                            alertType = ""
                            showAlert = true
                        }
                    }
                }
            )
        )
    }
    
    private var profilePicture: some View {
        Circle()
            .frame(width: 170, height: 170)
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: "pencil")
                    .font(.title2)
                    .padding(10)
                    .background(
                        Circle()
                            .fill(Color.theme.skyBlue)
                    )
            }
    }
    
    private var profileDetails: some View {
        VStack(spacing: 4) {
            Text("Full Name")
                .foregroundStyle(Color.theme.title)
                .font(.title)
                .bold()
            
            Text("adi.amoyal02@gmail.com")
                .disabled(true)
                .font(.headline)
        }
    }
    
    private var statusPicker: some View {
        NavigationLink {
            StatusPickerView(selectedStatus: $viewModel.selectedStatus)
        } label: {
            HStack {
                Text("Status - \(viewModel.selectedStatus.title)")
                Spacer()
                Image(systemName: "chevron.right")
            }
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.theme.stroke ,lineWidth: 2)
            )
        }
    }
    
    private var buttonsSection: some View {
        VStack {
            if viewModel.authProviders.contains(.email) {
                CustomActionButton(action: {
                    Task {
                        do {
                            try await viewModel.resetPassword()
                            print("PASSWORD RESET!")
                        } catch {
                            print(error)
                        }
                    }
                }, title: "Reset password", color: .theme.primaryBlue)
            }
            
            CustomActionButton(action: {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }, title: "Sign out", color: .theme.primaryBlue)
            
            CustomActionButton(action: {
                alertMessage = "Are you sure you want to delete your account? This action cannot be undone"
                alertType = "delete"
                showAlert.toggle()
            }, title: "Delete account", color: .theme.red)
        }
    }
    
}
