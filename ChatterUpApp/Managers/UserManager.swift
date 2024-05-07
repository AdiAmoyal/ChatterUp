//
//  UserManager.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 03/05/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

struct DBUser: Codable {
    let userId: String
    let email: String?
    let photoUrl: String?
    let fullName: String?
    let nickname: String?
    let profilePicture: String?
    let status: StatusOption?
    let dateCreated :Date?
    
    init(auth: AuthDataResultModel,
         fullName: String? = nil,
         nickname: String? = nil,
         profilePicture: String? = nil
    ) {
        self.userId = auth.uid
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.fullName = fullName
        self.nickname = nickname
        self.profilePicture = profilePicture
        self.status = .available
        self.dateCreated = Date()
    }
    
    init(userId: String,
         email: String? = nil,
         photoUrl: String? = nil,
         fullName: String? = nil,
         nickname: String? = nil,
         status: StatusOption? = nil,
         profilePicture: String? = nil,
         dateCreated :Date? = nil
    ) {
        self.userId = userId
        self.email = email
        self.photoUrl = photoUrl
        self.fullName = fullName
        self.nickname = nickname
        self.profilePicture = profilePicture
        self.status = status
        self.dateCreated = dateCreated
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email = "email"
        case photoUrl = "photo_url"
        case fullName = "full_name"
        case nickname = "nickname"
        case profilePicture = "profile_picture"
        case status = "status"
        case dateCreated = "date_created"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.fullName = try container.decodeIfPresent(String.self, forKey: .fullName)
        self.nickname = try container.decodeIfPresent(String.self, forKey: .nickname)
        self.profilePicture = try container.decodeIfPresent(String.self, forKey: .profilePicture)
        self.status = try container.decodeIfPresent(StatusOption.self, forKey: .status)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.fullName, forKey: .fullName)
        try container.encodeIfPresent(self.nickname, forKey: .nickname)
        try container.encodeIfPresent(self.profilePicture, forKey: .profilePicture)
        try container.encodeIfPresent(self.status, forKey: .status)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
    }
    
}

final class UserManager: ObservableObject {
    
    static let shared = UserManager()
    
    @Published var currentUser: DBUser? // Current authenticated user
    
    private init() { }
    
    func saveAuthenticatedUser(userId: String) async throws {
        self.currentUser = try await getUser(userId: userId)
    }
    
    private var userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func createNewUser(user: DBUser) async throws {
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> DBUser {
        try await userDocument(userId: userId).getDocument(as: DBUser.self)
    }
    
    func getAllUsers() async throws -> [DBUser] {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        let user = try await getUser(userId: authUser.uid)
        
        return try await userCollection
            .whereField(DBUser.CodingKeys.userId.rawValue, isNotEqualTo: user.userId)
            .getDocuments(as: DBUser.self)
    }
    
    func updateUserDetails(userId: String, nickname: String, status: StatusOption) async throws {
        let data: [String: Any] = [
            "nickname": nickname,
            "status": status.rawValue
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func deleteUser(userId: String) async throws {
        try await userDocument(userId: userId).delete()
    }
}
