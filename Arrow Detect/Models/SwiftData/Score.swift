//
//  Score.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 06/03/2025.
//

import Foundation
import SwiftData

@Model
final class Score {
    @Relationship(deleteRule: .nullify) var archer: Archer
    var date: Date
    var bowType: String
    var targetSize: Int
    var distance: Int
    var scoreTotal: Int
    @Relationship(deleteRule: .cascade, inverse: \End.score) var ends = [End]()
    @Relationship(deleteRule: .cascade, inverse: \Stat.score) var stat: Stat?
    
    init (archer: Archer, date: Date, bowType: String, targetSize: Int, distance: Int, scoreTotal: Int, stat: Stat? = nil) {
        self.archer = archer
        self.date = date
        self.bowType = bowType
        self.targetSize = targetSize
        self.distance = distance
        self.scoreTotal = scoreTotal
        self.stat = stat
    }
}
