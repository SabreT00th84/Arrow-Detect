//
//  AwardStatus.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 10/03/2025.
//

import Foundation

struct AwardStatus: Codable {
    var archerId: String
    var awardId: String
    var completionPercentage: Float
    var isVerified: Bool
    var dateCompleted: Date
}
