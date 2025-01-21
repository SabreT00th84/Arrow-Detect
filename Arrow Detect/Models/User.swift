//
//  User.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 26/12/2024.
//

import Foundation

struct User: Codable  {
    let id: String
    let name: String
    let email: String
    let joinDate: TimeInterval
    let isInstructor: Bool
    let publicId: String
}
