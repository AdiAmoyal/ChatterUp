//
//  ChatMessageRowView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 08/05/2024.
//

import SwiftUI

struct ChatMessageRowView: View {
    
    let message: Message
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(message.content ?? "")
                .font(.body)
            
            Text(message.formattedTimeCreated)
                .font(.footnote)
        }
        .padding()
        .foregroundStyle(Color.white)
        .background(message.senderId == "1" ? Color.theme.primaryBlue : Color.theme.icon)
        .cornerRadius(15)
        .frame(maxWidth: .infinity, alignment: message.senderId == "1" ? .trailing : .leading)
    }
}

#Preview {
    ChatMessageRowView(message: Message(id: "1", senderId: "1", content: "How are you?", isRead: true, type: .text, timeCreated: Date()))
}
