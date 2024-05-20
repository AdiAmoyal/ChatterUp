//
//  Message.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 07/05/2024.
//

import Foundation

struct Message: Hashable, Codable {
    let id: String
    let senderId: String?   // ID of the user who sent the message
    let content: String?
    let isRead: Bool?
    let type: MessageType?
    let timeCreated: Date?
    
    var formattedTimeCreated: String {
        // Format the timestamp for display (e.g., "HH:mm" or "dd/MM/yyyy HH:mm")
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"  // Customize date format as needed
        return formatter.string(from: timeCreated ?? Date())
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case senderId = "sender_id"
        case content = "content"
        case isRead = "is_read"
        case type = "type"
        case timeCreated = "time_created"
    }
    
    init(id: String,
         senderId: String? = nil,
         content: String? = nil,
         isRead: Bool? = nil,
         type: MessageType? = nil,
         timeCreated: Date? = nil
    ) {
        self.id = id
        self.senderId = senderId
        self.content = content
        self.isRead = isRead
        self.type = type
        self.timeCreated = timeCreated
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.senderId = try container.decodeIfPresent(String.self, forKey: .senderId)
        self.content = try container.decodeIfPresent(String.self, forKey: .content)
        self.isRead = try container.decodeIfPresent(Bool.self, forKey: .isRead)
        self.type = try container.decodeIfPresent(MessageType.self, forKey: .type)
        self.timeCreated = try container.decodeIfPresent(Date.self, forKey: .timeCreated)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encodeIfPresent(self.senderId, forKey: .senderId)
        try container.encodeIfPresent(self.content, forKey: .content)
        try container.encodeIfPresent(self.isRead, forKey: .isRead)
        try container.encodeIfPresent(self.type, forKey: .type)
        try container.encodeIfPresent(self.timeCreated, forKey: .timeCreated)
    }
    
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    //    static var message = Message(id: "1", senderId: "1", content: "How are you?", isRead: true, type: .text, timeCreated: Date())
    //
    //    static var messages: [Message] = [
    //        Message(id: "1", senderId: "1", content: "How are you?", isRead: true, type: .text, timeCreated: Date()),
    //        Message(id: "2", senderId: "2", content: "I'm good, thanks!, what about you?", isRead: true, type: .text, timeCreated: Date().addingTimeInterval(60)),
    //        Message(id: "3", senderId: "1", content: "I'm good too", isRead: true, type: .text, timeCreated: Date().addingTimeInterval(120)),
    //        Message(id: "4", senderId: "1", content: "Want to grab lunch tomorrow?", isRead: true, type: .text, timeCreated: Date().addingTimeInterval(140)),
    //        Message(id: "5", senderId: "2", content: "Sure, let's meet at noon.", isRead: true, type: .text, timeCreated: Date().addingTimeInterval(200)),
    //        Message(id: "6", senderId: "2", content: "Hi there!", isRead: true, type: .text, timeCreated: Date().addingTimeInterval(500)),
    //        Message(id: "7", senderId: "1", content: "Good morning", isRead: true, type: .text, timeCreated: Date().addingTimeInterval(560)),
    //        Message(id: "8", senderId: "2", content: "How was your weekend?", isRead: true, type: .text, timeCreated: Date().addingTimeInterval(620)),
    //        Message(id: "9", senderId: "1", content: "It was great, thanks!", isRead: true, type: .text, timeCreated: Date().addingTimeInterval(680)),
    //        Message(id: "10", senderId: "2", content: "Let's meet at 2 pm today", isRead: true, type: .text, timeCreated: Date().addingTimeInterval(740)),
    //        Message(id: "11", senderId: "1", content: "Sure, sounds good", isRead: true, type: .text, timeCreated: Date().addingTimeInterval(800)),
    //        Message(id: "12", senderId: "1", content: "Good morning", isRead: true, type: .text, timeCreated: Date().addingTimeInterval(1500)),
    //        Message(id: "13", senderId: "1", content: "Did you watch the game last night?", isRead: true, type: .text, timeCreated: Date().addingTimeInterval(1530)),
    //        Message(id: "14", senderId: "2", content: "Yes, it was exciting!", isRead: true, type: .text, timeCreated: Date().addingTimeInterval(1590)),
    //        Message(id: "15", senderId: "1", content: "I couldn't believe the final score!", isRead: true, type: .text, timeCreated: Date().addingTimeInterval(1650)),
    //        Message(id: "16", senderId: "1", content: "Are you free for lunch today?", isRead: true, type: .text, timeCreated: Date().addingTimeInterval(1710)),
    //        Message(id: "17", senderId: "2", content: "Sorry, I have a meeting at noon", isRead: true, type: .text, timeCreated: Date().addingTimeInterval(1770)),
    //    ]
}

enum MessageType: String, Codable {
    case text, image
}
