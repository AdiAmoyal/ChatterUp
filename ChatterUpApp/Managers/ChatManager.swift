//
//  ChatManager.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 07/05/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Chat: Identifiable, Codable, Equatable {
    let id: String
    let participents: [DBUser]
    let lastMessage: Message?
    let timeCreated: Date?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case participents = "participents"
        case lastMessage = "last_message"
        case timeCreated = "time_created"
    }
    
    init(id: String,
         participents: [DBUser] = [],
         lastMessage: Message? = nil,
         timeCreated: Date? = nil
    ) {
        self.id = id
        self.participents = participents
        self.lastMessage = lastMessage
        self.timeCreated = timeCreated
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.participents = try container.decodeIfPresent([DBUser].self, forKey: .participents) ?? []
        self.lastMessage = try container.decodeIfPresent(Message.self, forKey: .lastMessage)
        self.timeCreated = try container.decodeIfPresent(Date.self, forKey: .timeCreated)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.participents, forKey: .participents)
        try container.encodeIfPresent(self.lastMessage, forKey: .lastMessage)
        try container.encodeIfPresent(self.timeCreated, forKey: .timeCreated)
    }
    
    static func ==(lhs: Chat, rhs: Chat) -> Bool {
        return lhs.id == rhs.id
    }
}

final class ChatManager {
    
    static let shared = ChatManager()
    private init() { }
    
    private var chatsCollection = Firestore.firestore().collection("chats")
    
    private func chatDocument(chatId: String) -> DocumentReference {
        chatsCollection.document(chatId)
    }
    
    private func chatMessagesCollection(chatId: String) -> CollectionReference {
        chatDocument(chatId: chatId).collection("messages")
    }
    
    private func chatMessageDocument(chatId: String, messageId: String) -> DocumentReference {
        chatMessagesCollection(chatId: chatId).document(messageId)
    }
    
    func createNewChat(for participents: [DBUser]) async throws -> Chat {
        let document = chatsCollection.document()
        let chat = Chat(
            id: document.documentID,
            participents: participents,
            lastMessage: Message(id: ""),
            timeCreated: Date()
        )
        try document.setData(from: chat, merge: false)
        try UserManager.shared.addUserChat(userId: participents[0].userId, chat: chat)
        try UserManager.shared.addUserChat(userId: participents[1].userId, chat: chat)
        return chat
    }
    
    func addNewMessage(chatId: String, senderId: String, content: String, chatWith: String) async throws {
        let document = chatMessagesCollection(chatId: chatId).document()
        let message = Message(
            id: document.documentID,
            senderId: senderId,
            content: content,
            isRead: false,
            type: .text,
            timeCreated: Date())
        
        try document.setData(from: message, merge: false)
        try await UserManager.shared.updateUserChatLastMessage(chatId: chatId, userId: senderId, message: message)
        try await UserManager.shared.updateUserChatLastMessage(chatId: chatId, userId: chatWith, message: message)
    }
    
    func removeMessage(chatId: String, messageId: String) async throws {
        try await chatMessageDocument(chatId: chatId, messageId: messageId).delete()
    }
    
    func getAllChatMessages(chatId: String, lastDocument: DocumentSnapshot?) async throws -> (documents: [Message], lastDocument: DocumentSnapshot?) {
        try await chatMessagesCollection(chatId: chatId)
            .order(by: Message.CodingKeys.timeCreated.rawValue, descending: false)
            .limit(to: 20)
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: Message.self)
    }

}
