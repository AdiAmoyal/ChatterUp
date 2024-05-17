//
//  ChatRowView.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 06/05/2024.
//

import SwiftUI

struct ChatRowView: View {
    
    let chatWith: DBUser
    let lastMessage: Message
    let newMessagesCount: Int
    
    var body: some View {
        HStack(spacing: 2) {
            Circle()
                .frame(width: 53, height: 53)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    name
                    Spacer()
                    time
                }

                HStack(spacing: 4) {
                    content
                    Spacer()

                    newMessagesSymbol
                        .opacity(newMessagesCount > 0 ? 1 : 0)
                }
            }
        }
        .frame(height: 65)
        .padding(.vertical, 2)
    }
}

//#Preview {
//    ChatRowView(chat: Chat(id: "1", participents: ["1", "2"], lasMessage: Message.messages.last ?? Message.message, messages: Message.messages), newMessagesCount: 0)
//}

extension ChatRowView {
    
    private var name: some View {
        Text(chatWith.fullName ?? "No name")
            .font(.headline)
            .foregroundStyle(Color.theme.primaryBlue)
    }
    
    private var time: some View {
        Text(lastMessage.formattedTimeCreated)
            .font(.footnote)
            .bold()
    }
    
    private var content: some View {
        Text(lastMessage.content ?? "")
            .font(.subheadline)
            .multilineTextAlignment(.leading)
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(maxHeight: .infinity, alignment: .top)
    }
    
    private var newMessagesSymbol: some View {
        Text("\(newMessagesCount)")
            .font(.caption)
            .foregroundStyle(Color.white)
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.theme.red)
                    .frame(minWidth: 17)
                    .frame(height: 17)
            )
            .padding(.trailing, 8)
            .frame(maxHeight: .infinity, alignment: .top)
    }
}
