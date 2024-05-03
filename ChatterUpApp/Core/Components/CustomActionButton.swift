//
//  CustomSignInButton.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 01/05/2024.
//

import SwiftUI

struct CustomActionButton: View {
    
    let action: () -> ()
    let title: String
    let color: Color
    
    var body: some View {
        Button(action: { action() }, label: {
            Text(title)
                .foregroundStyle(Color.white)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color)
                )
        })
    }
}

#Preview {
    CustomActionButton(action: {}, title: "Sign In", color: .theme.primaryBlue)
}
