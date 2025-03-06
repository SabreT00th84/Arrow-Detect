//
//  Score.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 06/03/2025.
//

import Foundation

struct Score: Codable {
    let scoreId: String
    let archerId: String
    let date: TimeInterval
    let bowType: String
    let targetSize: Int
    let distance: Int
    let scoreTotal: Int
    let instructorComment: String
}
