//
//  ScoresViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 26/11/2025.
//

import Foundation
import simd
import CoreGraphics
import CoreImage

enum TargetSize: Int, CaseIterable, Identifiable {
    
    case eighty = 80
    case sixty = 60
    case forty = 40
    
    var id: Self { self }
}

enum BowType: String, CaseIterable, Identifiable {
    
    case barebow = "Barebow"
    case recurve = "Recurve"
    
    var id: Self { self }
}

enum Distance: Int, CaseIterable, Identifiable {
    
    case ten = 10
    case fourteen = 14
    case eighteen = 18
    case twentyFive = 25
    case thirty = 30
    
    var id: Self { self }
}

@Observable
final class ScoresheetViewModel: Hashable {
    
    var ends: [SimpleEnd] = Array(repeating: SimpleEnd(arrows: Array(repeating: SimpleArrow(tip: Point(x: 0, y: 0), score: ""), count: 3)), count: 5)
    var error: Error?
    var selectedScanView: IdentifiableInt? = nil
    var selectedSize = TargetSize.eighty
    var selectedBow = BowType.barebow
    var selectedDistance = Distance.eighteen
    
    static func == (lhs: ScoresheetViewModel, rhs: ScoresheetViewModel) -> Bool {
        
            return lhs === rhs
        }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(ObjectIdentifier(self))
    }
    
    @MainActor
    func submit(archer: Archer?, prevStat: Stat?) throws -> Score {
        do {
            try validate()
            
            guard let archer else { throw QueryError.retrievalErrorFor(object: "archer") }
            let score = Score(archer: archer, date: Date.now,
                                    bowType: selectedBow.rawValue,
                                    targetSize: selectedSize.rawValue,
                                    distance: selectedDistance.rawValue,
                                    scoreTotal: 0)
            score.ends = ends.enumerated().map { createEndRecord(for: $1, with: score, index: $0) }
            score.scoreTotal = score.ends.reduce(0) { $0 + $1.endTotal }
            
            let groupRadii = try ends.map { try calculateGroupRadius(points: $0.arrows.map(\.tip)) }
            let stat = createStatsRecord(score: score, prevStat: prevStat, groupRadii: groupRadii)
            score.stat = stat
            
            return score
        } catch let error {
            self.error = error
            
            throw error
        }
    }
    
    private func validate() throws (ValidationError) {
        let flatArray = ends.flatMap{$0.arrows.map(\.score)}
        let intArray = flatArray.map{intScore(score: $0)}
        guard flatArray.filter({$0.trimmingCharacters(in: .whitespacesAndNewlines) == "" }).isEmpty else { throw .emptyFields }
        guard !intArray.contains(where: {$0 < 0 || $0 > 10}) else { throw .invalidScore }
    }
    
    func createEndRecord(for simpEnd: SimpleEnd, with score: Score, index: Int) -> End {
        let end = End(score: score, endNo: (index + 1), endTotal: 0, image: simpEnd.image?.jpegData)
        end.arrows = simpEnd.arrows.enumerated().map { (i, simpArrow) in
            Arrow(end: end, arrowNo: (i + 1), tip: Point(x: simpArrow.tip.x, y: simpArrow.tip.y), score: correctFormat(unformatted: simpArrow.score))
        }
        end.endTotal = end.arrows.reduce(0) { $0 + intScore(score: $1.score) }
        
        return end
    }
    
    private func correctFormat(unformatted: String) -> String {
        switch unformatted {
            case "x": return "X"
            case "m": return "M"
            case "0": return "M"
            default: return unformatted
        }
    }
    
    func intScore(score: String) -> Int {
        if score.uppercased() == "X" {
            return 10
        } else if score.uppercased() == "M"{
            return 0
        } else {
            return Int(score) ?? -1
        }
    }
    
    func calculateGroupRadius(points: [Point]) throws (ValidationError) -> Float {
        guard points.count == 3 else { throw .tooFewPoints }
        guard !(points[0] == points[1] || points [1] == points[2] || points[0] == points[2]) else { return 0 }
        
        let pointsMatrix = simd_float3x3(rows: points.prefix(3).map {simd_float3(2 * $0.x, 2 * $0.y, 1)})
        let squaredMatrix = simd_float3(points.prefix(3).map {-(pow($0.x, 2) + pow($0.y, 2))})
        let solution = pointsMatrix.inverse * squaredMatrix
        
        return sqrt(pow(solution.x, 2) + pow(solution.y, 2) - solution.z)
    }
    
    func createStatsRecord (score: Score, prevStat: Stat?, groupRadii: [Float]) -> Stat {
        let simplifiedScores = score.ends.flatMap{$0.arrows.map(\.score)}
        let intScores = simplifiedScores.map {self.intScore(score: $0)}
        let avgScore = Float(intScores.reduce(0, +))/Float(intScores.count)
        let avgGroupRad = groupRadii.reduce(0, +)/Float(groupRadii.count)
        let perfScore: Float
        let perfImprovement: Float
        
        if avgGroupRad != 0 {
            perfScore = Float(score.scoreTotal)/avgGroupRad
        } else {
            perfScore = Float(score.scoreTotal)
        }
        
        if let prevStat, prevStat.perfScore > 0 {
            perfImprovement = ((perfScore - prevStat.perfScore)/prevStat.perfScore)
        } else {
            perfImprovement = 0
        }
        
        let statObject =  Stat(score: score, avgScore: avgScore,
                               noOfScoresEach: [
                                simplifiedScores.count {$0 == "M"},
                                simplifiedScores.count {$0 == "1"},
                                simplifiedScores.count {$0 == "2"},
                                simplifiedScores.count {$0 == "3"},
                                simplifiedScores.count {$0 == "4"},
                                simplifiedScores.count {$0 == "5"},
                                simplifiedScores.count {$0 == "6"},
                                simplifiedScores.count {$0 == "7"},
                                simplifiedScores.count {$0 == "8"},
                                simplifiedScores.count {$0 == "9"},
                                simplifiedScores.count {$0 == "10"},
                                simplifiedScores.count {$0 == "X"},
                               ],
                               avgEndGroupradius: avgGroupRad,
                               perfScore: perfScore,
                               perfImprovement: perfImprovement)
        return statObject
    }
}
