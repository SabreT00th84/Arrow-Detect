//
//  Stat.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 06/03/2025.
//

import Foundation
import SwiftData

@Model
final class Stat {
    @Relationship(deleteRule: .nullify) var score: Score
    var avgScore: Float
    var noOfScoresEach: [Int]
    var avgEndGroupradius: Float
    var perfScore: Float
    var perfImprovement: Float
    
    init(score: Score, avgScore: Float, noOfScoresEach: [Int], avgEndGroupradius: Float, perfScore: Float, perfImprovement: Float) {
        self.score = score
        self.avgScore = avgScore
        self.noOfScoresEach = noOfScoresEach
        self.avgEndGroupradius = avgEndGroupradius
        self.perfScore = perfScore
        self.perfImprovement = perfImprovement
    }
}
