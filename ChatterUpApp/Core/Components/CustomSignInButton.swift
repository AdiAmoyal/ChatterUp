//
//  CustomSignInButton.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 01/05/2024.
//

import SwiftUI

struct CustomSignInButton: View {
    
    let action: () -> ()
    let title: String
    
    var body: some View {
        Button(action: { action() }, label: {
            Text(title)
                .foregroundStyle(Color.white)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.theme.primaryBlue)
                )
        })
    }
}

#Preview {
    CustomSignInButton(action: {}, title: "Sign In")
}
