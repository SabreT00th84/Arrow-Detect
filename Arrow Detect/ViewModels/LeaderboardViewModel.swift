//
//  LeaderboardViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 09/03/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@Observable
class LeaderboardViewModel {
    var topScores: [(User, Score)] = []
    var selectedInterval = 7
    var errorMessage: String?
    
    init () {
        Task {
            await loadTopScores(dayInterval: selectedInterval)
        }
    }
    
    func getUser(archerId: String) async throws -> User {
        do {
            let db = Firestore.firestore()
            let archer = try await db.collection("Archers").document(archerId).getDocument(as: Archer.self)
            return try await db.collection("Users").document(archer.userId).getDocument(as: User.self)
        } catch let error {
            throw error
        }
    }
    
    func loadTopScores(dayInterval: Int) async {
        do {
            let db = Firestore.firestore()
            
            guard let timeDifference = Calendar.current.date(byAdding: .day, value: -dayInterval, to: .now) else {
                errorMessage = "Could not calculate time difference"
                return
            }
            
           guard let userId = Auth.auth().currentUser?.uid else {
               errorMessage = "Usre is not signed in"
                return
            }
            guard let archer = try await db.collection("Archers").whereField("userId", isEqualTo: userId).getDocuments().documents.first?.data(as: Archer.self) else {
                errorMessage = "Could not retrieve archer record"
                return
            }
           /* guard archer.instructorId != "" else {
                errorMessage = "Please join a club before using the leaderboard feature"
                return
            }*/
            
            let allClubArcherIds = try await db.collection("Archers").whereField("instructorId", isEqualTo: archer.instructorId).getDocuments().documents.map({try $0.data(as: Archer.self).archerId})
            let scores = try await db.collection("Scores").whereField("archerId", in: allClubArcherIds as [Any]).whereField("date", isGreaterThan: timeDifference).getDocuments().documents.map({try $0.data(as: Score.self)})
            let topArcherIds = Set(scores.map(\.archerId))
            var tempScores: [(User, Score)] = []
            for id in topArcherIds {
                let archerScores = scores.filter({$0.archerId == id}).sorted {$0.scoreTotal > $1.scoreTotal}
                guard let firstScore = archerScores.first else {
                    print( "No scores for archer \(id)")
                    continue
                }
                try await tempScores.append((getUser(archerId: id), firstScore))
            }
            let sorted = tempScores.sorted(by: {$0.1.scoreTotal > $1.1.scoreTotal})
            topScores = sorted
        } catch let error {
            print("Error in leaderboard:")
            print(error)
            print("end error----------")
        }
    }
}
