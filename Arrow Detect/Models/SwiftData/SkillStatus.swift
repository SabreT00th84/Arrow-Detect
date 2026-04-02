//
//  SkillStatus.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 17/08/2025.
//

import Foundation
import SwiftData

@Model
final class SkillStatus {
    @Relationship(deleteRule: .nullify) var awardStatus: AwardStatus?
    @Relationship(deleteRule: .nullify) var skill: Skill
    @Relationship(deleteRule: .cascade, inverse: \RequirementStatus.skillStatus) var requirementStatuses = [RequirementStatus]()
    var noCompleted: Int { return requirementStatuses.filter(\.isCompleted).count }
    var completionRatio: Float {
        return Float(noCompleted) / Float(skill.noOfRequirements)
    }
    var isCompleted: Bool { return noCompleted == skill.noOfRequirements }
    
    init(awardStatus: AwardStatus, skill: Skill) {
        self.awardStatus = awardStatus
        self.skill = skill
    }
}
