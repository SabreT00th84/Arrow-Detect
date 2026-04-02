//
//  AwardStatus.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 10/03/2025.
//

import Foundation
import SwiftData

@Model
final class AwardStatus {
    @Relationship(deleteRule: .nullify) var archer: Archer?
    @Relationship(deleteRule: .nullify) var award: Award
    @Relationship(deleteRule: .cascade, inverse: \SkillStatus.awardStatus) var skillStatuses = [SkillStatus]()
    var noCompleted: Int {
        let completed = skillStatuses.flatMap(\.requirementStatuses).filter(\.isCompleted).count
        
        if completed == award.noOfRequirements {
            self.dateCompleted = Date()
        }
        
        return completed
    }
    var completionRatio: Float {
        return Float(noCompleted) / Float(award.noOfRequirements)
    }
    var isCompleted: Bool { return noCompleted == award.noOfRequirements }
    var dateCompleted: Date? = nil
    
    init(archer: Archer, award: Award) {
        self.archer = archer
        self.award = award
    }
}
