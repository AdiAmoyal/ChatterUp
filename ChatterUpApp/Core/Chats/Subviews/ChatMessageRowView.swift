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
                .multilineTextAlignment(.leading)
                .lineLimit(10)
            
            Text(message.formattedTimeCreated)
                .font(.footnote)
        }
        .padding()
        .foregroundStyle(Color.white)
        .frame(minWidth: 80)
    }
}

#Preview {
    ChatMessageRowView(message: Message(id: "1", senderId: "1", content: "Hi", isRead: true, type: .text, timeCreated: Date()))
        .background(Color.blue)
}
