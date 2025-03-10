//
//  StatsViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 08/03/2025.
//

import Foundation
import FirebaseFirestore

@Observable
class StatsViewModel {
    let score: Score
    var stat: Stat?
    var ends: [End] = []
    var arrows: [[Arrow]] = []
    var tableData: [ScoreTableRow] = []
    var verification = ""
    
    init(score: Score) {
        self.score = score
    }
    
    @MainActor
    func loadData() async {
        do {
            let db = Firestore.firestore()
            ends = try await db.collection("Ends").whereField("scoreId", isEqualTo: score.scoreId!).getDocuments().documents.map({try $0.data(as: End.self)})
            stat = try await db.collection("Stats").whereField("scoreId", isEqualTo: score.scoreId!).getDocuments().documents.first?.data(as: Stat.self)
            
            var tempArrows: [[Arrow]] = []
            for end in ends {
                let array = try await db.collection("Arrows").whereField("endId", isEqualTo: end.endId!).getDocuments().documents.map({try $0.data(as: Arrow.self)})
                tempArrows.append(array)
            }
            
            arrows = tempArrows
            
            generateTableData()
            verify()
            print(tableData)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    private func generateTableData() {
        for (i, end) in arrows.enumerated() {
            let endScores = end.map {$0.score}
            let tableRow = ScoreTableRow(endNo: String(i + 1),
                          arrow1: endScores[0],
                          arrow2: endScores[1],
                          arrow3: endScores[2],
                          endTotal: String(ends[i].endTotal))
            tableData.append(tableRow)
        }
    }
    
    func verify() {
        if ends.filter({!$0.isVerified}).isEmpty {
            verification = "✅"
        } else {
            verification = "❌"
        }
    }
}
