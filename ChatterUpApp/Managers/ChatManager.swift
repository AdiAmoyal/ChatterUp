//
//  ChatManager.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 07/05/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Chat: Identifiable, Codable {
    let id: String
    let participents: [DBUser]?
    let lastMessage: Message?
    let messages: [Message]?
    let timeCreated: Date?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case participents = "participents"
        case lastMessage = "last_message"
        case messages = "messages"
        case timeCreated = "time_created"
    }
    
    init(id: String,
         participents: [DBUser]? = nil,
         lastMessage: Message? = nil,
         messages: [Message]? = nil,
         timeCreated: Date? = nil
    ) {
        self.id = id
        self.participents = participents
        self.lastMessage = lastMessage
        self.messages = messages
        self.timeCreated = timeCreated
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.participents = try container.decodeIfPresent([DBUser].self, forKey: .participents)
        self.lastMessage = try container.decodeIfPresent(Message.self, forKey: .lastMessage)
        self.messages = try container.decodeIfPresent([Message].self, forKey: .messages)
        self.timeCreated = try container.decodeIfPresent(Date.self, forKey: .timeCreated)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.participents, forKey: .participents)
        try container.encodeIfPresent(self.lastMessage, forKey: .lastMessage)
        try container.encodeIfPresent(self.messages, forKey: .messages)
        try container.encodeIfPresent(self.timeCreated, forKey: .timeCreated)
    }
}

final class ChatManager {
    
    static let shared = ChatManager()
    private init() { }
    
    private var chatsCollection = Firestore.firestore().collection("chats")
    
    private func chatDocument(chatId: String) -> DocumentReference {
        chatsCollection.document(chatId)
    }
    
    func createNewChat(for participents: [DBUser]) async throws -> Chat {
        let document = chatsCollection.document()
        let chat = Chat(
            id: document.documentID,
            participents: participents,
            lastMessage: nil,
            messages: [],
            timeCreated: Date()
        )
        try document.setData(from: chat, merge: false)
        try UserManager.shared.addUserChat(userId: participents[0].userId, chat: chat)
        try UserManager.shared.addUserChat(userId: participents[1].userId, chat: chat)
        return chat
    }
    
}
