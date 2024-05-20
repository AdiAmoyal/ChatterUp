//
//  Query.swift
//  ChatterUpApp
//
//  Created by Adi Amoyal on 07/05/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

extension Query {
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        try await getDocumentsWithSnapshot(as: type).documents
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (documents: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()
        let documents = try snapshot.documents.map({ try $0.data(as: T.self) })
        return (documents, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
    
}
