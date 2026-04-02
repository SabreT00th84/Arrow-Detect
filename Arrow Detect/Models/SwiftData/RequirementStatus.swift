//
//  RequirementStatus.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 11/03/2025.
//

import Foundation
import SwiftData

@Model
final class RequirementStatus {
    @Relationship(deleteRule: .nullify) var skillStatus: SkillStatus?
    @Relationship(deleteRule: .nullify) var requirement: Requirement
    var isCompleted: Bool
    
    init(skillStatus: SkillStatus, requirement: Requirement, isCompleted: Bool = false) {
        self.skillStatus = skillStatus
        self.requirement = requirement
        self.isCompleted = isCompleted
    }
}
