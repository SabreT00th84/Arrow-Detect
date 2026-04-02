//
//  Requirement.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 11/03/2025.
//

import Foundation
import SwiftData

@Model
final class Requirement {
    @Relationship(deleteRule: .deny) var skill: Skill
    var desc: String
    var requirementNo: Int
    
    init(skill: Skill, description: String, requirementNo: Int) {
        self.skill = skill
        self.desc = description
        self.requirementNo = requirementNo
    }
}
