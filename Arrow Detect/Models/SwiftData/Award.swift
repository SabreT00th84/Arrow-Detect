//
//  Award.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 10/03/2025.
//

import Foundation
import SwiftData

@Model
final class Award {
    var name: String
    var maximumTargetSize: Int
    var minimumDistance: Int
    var noOfRequirements: Int
    var awardNo: Int
    @Relationship(deleteRule: .deny, inverse: \Skill.award) var skills = [Skill]()
    
    init(name: String, maximumTargetSize: Int, minimumDistance: Int, noOfRequirements: Int, awardNo: Int) {
        self.name = name
        self.maximumTargetSize = maximumTargetSize
        self.minimumDistance = minimumDistance
        self.noOfRequirements = noOfRequirements
        self.awardNo = awardNo
    }
}
