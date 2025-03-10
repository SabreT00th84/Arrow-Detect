//
//  InfoViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 10/03/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@Observable
class AwardsViewModel {
    
    var archerAwards: [(Award, AwardStatus)] = []
    
    init () {
        Task {
            await loadData()
        }
    }
    
    @MainActor
    func loadData() async {
        do {
            let db = Firestore.firestore()
            var awards = try await db.collection("Awards").getDocuments().documents.map {try $0.data(as: Award.self)}
            awards.sort(by: {$0.awardId! < $1.awardId!})
            guard let userId = Auth.auth().currentUser?.uid else {
                print("User not logged in")
                return
            }
            let archerId = try await db.collection("Archers").whereField("userId", isEqualTo: userId).getDocuments().documents.first?.data(as: Archer.self).archerId
            guard let archerId else {
                print("Could not retrieve archer record")
                return
            }
            var awardStatus = try await loadAwardStatus(archerId: archerId)
            if awardStatus.count == 0 {
                for award in awards {
                    let statusObject = AwardStatus(archerId: archerId, awardId: award.awardId!, completionRatio: 0, isVerified: false, dateCompleted: nil)
                    try db.collection("AwardStatus").document().setData(from: statusObject)
                    awardStatus.append(statusObject)
                }
            }
            var tempArcherAwards: [(Award, AwardStatus)] = []
            
            awardStatus = awardStatus.sorted(by: {$0.awardId < $1.awardId})
            for (award, awardStatus) in zip(awards, awardStatus) {
                tempArcherAwards.append((award, awardStatus))
            }
            archerAwards = tempArcherAwards
        } catch let error {
            print("Error in awards:")
            print(error)
            print("end error ---------")
        }
    }
    
    func loadAwardStatus(archerId: String) async throws -> [AwardStatus] {
        do {
            let db = Firestore.firestore()
            let status = try await db.collection("Awards").whereField("archerId", isEqualTo: archerId).getDocuments().documents.map {try $0.data(as: AwardStatus.self)}
            return status
        } catch let error {
            throw error
        }
    }
}
