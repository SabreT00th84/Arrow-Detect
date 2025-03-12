//
//  AwardDetailViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 10/03/2025.
//

import Foundation
import FirebaseFirestore

@Observable
class AwardDetailViewModel {
    let awardTuple: (Award, AwardStatus)
    let archer: Archer?
    var requirementsTuple: [(Requirement, RequirementStatus)] = []
    var qualifyingScore: Score?
    
    @ObservationIgnored var verification: String {
        if awardTuple.1.isVerified {
            return "✅"
        } else {
            return "❌"
        }
    }
    
    func toggleStatus(tuple: (Requirement, RequirementStatus)) {
        do {
            let db = Firestore.firestore()
            var isCompleted = tuple.1.isCompleted
            isCompleted.toggle()
            let newStatus = RequirementStatus(archerId: tuple.1.archerId, requirementId: tuple.1.requirementId, isCompleted: isCompleted)
            try db.collection("RequirementStatus").document(tuple.1.requirementStatusId!).setData(from: newStatus, merge: true)
            let index = requirementsTuple.firstIndex(where: {$0.0.requirementId == tuple.0.requirementId})
            requirementsTuple.remove(at: index!)
            requirementsTuple.insert((tuple.0, newStatus), at: index!)
            
        }catch let error {
            print(error)
        }
    }
    
    private func loadData() async {
        do {
            let db = Firestore.firestore()
            guard let archer = archer, let archerId = archer.archerId else {
                print("Could not retrieve archer record")
                return
            }
            let requirements = try await db.collection("Requirements").whereField("awardId", isEqualTo: awardTuple.0.awardId!).getDocuments().documents.map {try $0.data(as: Requirement.self)}
            let status = try await db.collection("RequirementsStatus").whereField("archerId", isEqualTo: archerId).getDocuments().documents.map {try $0.data(as: RequirementStatus.self)}
            var tempStatus: [RequirementStatus] = []
            if status.count == 0 {
                for requirement in requirements {
                    let statusObject = RequirementStatus(archerId: archerId, requirementId: requirement.requirementId!, isCompleted: false)
                    try db.collection("RequirementsStatus").addDocument(from: statusObject)
                    tempStatus.append(statusObject)
                }
            }
            
            var tupleArray: [(Requirement, RequirementStatus)] = []
            for (requirement, status) in zip(requirements, status) {
                tupleArray.append((requirement, status))
            }
            
            requirementsTuple = tupleArray
            try await loadQualifyingScore()
            
        }catch let error {
            print(error)
        }
    }
    
    private func loadQualifyingScore() async throws{
        do {
            let db = Firestore.firestore()
            let scores = try await db.collection("Scores").whereField("archerId", isEqualTo: awardTuple.1.archerId).whereField("targetSize", isLessThanOrEqualTo: awardTuple.0.maximumTargetSize).whereField("distance", isGreaterThanOrEqualTo: awardTuple.0.minimumDistance).getDocuments().documents.map({try $0.data(as: Score.self)})
            
            var qualifyingScores: [Score] = []
            for score in scores {
                let minimumScore = try minimumScore(score: score)
                if score.scoreTotal >= minimumScore {
                    qualifyingScores.append(score)
                }
            }
            qualifyingScores = qualifyingScores.sorted(by: {$0.scoreTotal > $1.scoreTotal})
            qualifyingScore = qualifyingScores.first
            
        } catch let error {
            throw error
        }
    }
    
    private func minimumScore(score: Score) throws -> Int {
        let bowType = score.bowType
        if bowType == "Barebow" {
            return 86
        } else if bowType == "Recurve" {
            return 115
        } else {
            throw NSError(domain: "minimumScore()", code: -1, userInfo: ["description": "Could not calculate minimum score for score \(score.scoreId ?? "")"])
        }
    }
    
    init(awardTuple: (Award, AwardStatus), archer: Archer?) {
        self.awardTuple = awardTuple
        self.archer = archer
        Task {
            await loadData()
        }
    }
}
