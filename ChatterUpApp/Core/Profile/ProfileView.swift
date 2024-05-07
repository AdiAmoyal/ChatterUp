//
//  ProfileView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 02/05/2024.
//

import SwiftUI

struct ProfileLoadingView: View {
    
    @Binding var currentUser: DBUser?
    @Binding var showSignInView: Bool
    
    init(user: Binding<DBUser?>, showSignInView: Binding<Bool>) {
        self._currentUser = user
        self._showSignInView = showSignInView
    }
    
    var body: some View {
        ZStack {
            if let user = currentUser {
                ProfileView(user: user, showSignInView: $showSignInView)
            } else {
                // TODO: Add No Data View
                Text("No User")
            }
        }
    }
    
}

struct ProfileView: View {
    
    @StateObject private var viewModel: ProfileViewModel
    @Binding var showSignInView: Bool
    @FocusState private var isNicknameFocused: Bool
    
    // Alert
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertType: String = ""
    
    init(user: DBUser, showSignInView: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
        self._showSignInView = showSignInView
    }
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 18) {
                        profilePicture
                        profileDetails
                    }
                    
                    VStack(spacing: 18) {
                        CustomTextField(text: $viewModel.nickName, symbol: "shared.with.you", placeHolder: viewModel.nickName, type: "Nickname")
                            .focused($isNicknameFocused)
                        
                        statusPicker
                        saveButton
                    }
                    .padding(.horizontal, 10)
                    
                    Spacer()
                    Divider()
                    
                    buttonsSection
                    
                }
            }
            .scrollIndicators(.hidden)
            .foregroundStyle(Color.theme.body)
            .padding()
        }
        .alert(isPresented: $showAlert, content: {
            getAlert(type: alertType)
        })
    }
}

#Preview {
    NavigationStack {
        ProfileView(user: DBUser(userId: "1", email: "a@test.gmail.com", photoUrl: nil, fullName: "Adi Amoyal", nickname: "Test", status: .atWork, profilePicture: nil, dateCreated: Date()), showSignInView: .constant(false))
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
            Text(viewModel.user.fullName ?? "No Fullname")
                .foregroundStyle(Color.theme.title)
                .font(.title)
                .bold()
            
            if viewModel.authProviders.contains(.email) {
                Text(viewModel.user.email ?? "No Email")
                    .disabled(true)
                    .font(.headline)
            }
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
    
    private var saveButton: some View {
        CustomActionButton(action: {
            Task {
                do {
                    try await viewModel.saveChanges()
                    isNicknameFocused = false
                    alertMessage = "saved Successfully"
                    alertType = ""
                    showAlert = true
                } catch {
                    alertMessage = error.localizedDescription
                    alertType = ""
                    showAlert = true
                }
            }
        }, title: "Save Changes", color: .theme.primaryBlue)
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
        .padding(.horizontal, 10)
    }
    
}
