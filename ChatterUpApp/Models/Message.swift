//
//  Message.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 07/05/2024.
//

import Foundation

struct Message {
    let id: String
    let senderId: String?   // ID of the user who sent the message
    let content: String?
    let isRead: Bool?
    let type: MessageType?
    let timeCreated: Date?
    
    var formattedTimeCreated: String {
        // Format the timestamp for display (e.g., "HH:mm" or "dd/MM/yyyy HH:mm")
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"  // Customize date format as needed
        return formatter.string(from: timeCreated ?? Date())
    }
}

enum MessageType {
    case text, image
}
