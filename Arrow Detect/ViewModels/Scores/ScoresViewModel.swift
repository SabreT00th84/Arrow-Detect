//
//  ScoresViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 06/03/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@Observable
class ScoresViewModel {
    
    @MainActor
    func loadScores () async -> [Score] {
        do {
            let db = Firestore.firestore()
            guard let userId  = Auth.auth().currentUser?.uid, let archerId = try await db.collection("Archers").whereField("userId", isEqualTo: userId).getDocuments().documents.first?.data(as: Archer.self).archerId else {
                print("User not logged in")
                return []
            }
            let documents = try await db.collection("Scores").whereField("archerId", isEqualTo: archerId).order(by: "date", descending: true).getDocuments().documents
            return try documents.map {try $0.data(as: Score.self)}
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func deleteRecords (scoreIds: [String]) async throws {
        do {
            let db = Firestore.firestore()
            for id in scoreIds {
                try await db.collection("Scores").document(id).delete()
                let endIdsToDelete = try await db.collection("Ends").whereField("scoreId", isEqualTo: id).getDocuments().documents.map {try $0.data(as: End.self).endId}
                for endId in endIdsToDelete {
                    try await db.collection("Ends").document(endId).delete()
                    let arrowIdsToDelete = try await db.collection("Arrows").whereField("endId", isEqualTo: endId).getDocuments().documents.map {try $0.data(as: Arrow.self).arrowId}
                    for arrowId in arrowIdsToDelete {
                        try await db.collection("Arrows").document(arrowId).delete()
                    }
                }
            }
        } catch let error {
            throw error
        }
    }
}
