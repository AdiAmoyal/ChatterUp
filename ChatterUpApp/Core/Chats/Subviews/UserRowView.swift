//
//  UserRowView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 16/05/2024.
//

import SwiftUI

struct UserRowView: View {
    
    let user: DBUser
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .frame(width: 40, height: 40)
            
            if let fullName = user.fullName,
               let status = user.status {
                VStack(alignment: .leading) {
                    Text(fullName)
                        .font(.headline)
                    Text(status.title)
                        .font(.subheadline)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
        .background(Color.clear)
    }
}

//#Preview {
//    UserRowView()
//}
