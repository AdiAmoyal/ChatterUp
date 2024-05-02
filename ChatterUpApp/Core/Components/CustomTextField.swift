//
//  CustomTextField.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 26/04/2024.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    @State private var showPassword: Bool = false
    @FocusState private var isFocus: Bool
    
    let symbol: String
    let placeHolder: String
    let type: String
    
    var body: some View {
        HStack {
            icon
            
            if type == "Password" {
                if showPassword {
                    textField
                        .overlay(alignment: .trailing) {
                            eyeIcon
                        }
                } else {
                    passwordSecureField
                        .overlay(alignment: .trailing) {
                            eyeIcon
                        }
                }
            } else {
                textField
            }
        }
        .foregroundStyle(Color.theme.body)
        .font(.headline)
        .padding(14)
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isFocus ? Color.theme.primaryBlue : Color.theme.stroke ,lineWidth: 1.5)
        )
        .overlay(alignment: .topLeading) {
            overlayText
        }
    }
}

#Preview {
    CustomTextField(text: .constant(""), symbol: "envelope", placeHolder: "Enter your email..", type: "Email")
}

extension CustomTextField {
    
    private var icon: some View {
        Image(systemName: symbol)
            .foregroundStyle(Color.theme.icon)
    }
    
    private var passwordSecureField: some View {
        SecureField(placeHolder, text: $text)
            .focused($isFocus)
            .disableAutocorrection(true)
            .foregroundStyle(Color.theme.title)
            .font(.headline)
    }
    
    private var textField: some View {
        TextField(placeHolder, text: $text)
            .focused($isFocus)
            .disableAutocorrection(true)
            .foregroundStyle(Color.theme.title)
            .font(.headline)
    }
    
    private var overlayText: some View {
        HStack(spacing: 2) {
            Text(type)
            Text("*")
                .foregroundStyle(Color.theme.red)
        }
        .foregroundStyle(Color.theme.body)
        .font(.caption)
        .bold()
        .padding(.horizontal, 3)
        .background(Color.theme.background)
        .offset(x: 12, y: -7)
    }
    
    private var eyeIcon: some View {
        Image(systemName: showPassword ? "eye.slash" : "eye")
            .foregroundStyle(Color.theme.icon)
            .onTapGesture {
                showPassword.toggle()
            }
    }
    
}
