//
//  User.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 26/12/2024.
//

import Foundation

struct User: Codable  {
    let userId: String
    let name: String
    let email: String
    let joinDate: Date
    let isInstructor: Bool
    let imageId: String
}
