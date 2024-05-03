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
            }
            .foregroundStyle(Color.theme.body)
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}

extension ProfileView {
    
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
}
