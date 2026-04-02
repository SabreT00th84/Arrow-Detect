//
//  Skill.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 04/08/2025.
//

import Foundation
import SwiftData

@Model
final class Skill {
    @Relationship(deleteRule: .deny) var award: Award
    var name: String
    var skillNo: Int
    @Relationship(deleteRule: .deny, inverse: \Requirement.skill) var requirements = [Requirement]()
    var noOfRequirements: Int { return requirements.count }
    
    init(award: Award, name: String, skillNo: Int) {
        self.award = award
        self.name = name
        self.skillNo = skillNo
    }
}
