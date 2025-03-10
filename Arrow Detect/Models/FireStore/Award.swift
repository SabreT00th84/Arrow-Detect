//
//  Award.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 10/03/2025.
//

import Foundation
import FirebaseFirestore

struct Award: Codable {
    @DocumentID var awardId: String?
    var name: String
    var noOfRequirements: Int
}
