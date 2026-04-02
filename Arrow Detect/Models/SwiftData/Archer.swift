//
//  Archer.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 20/01/2025.
//

import Foundation
import SwiftData
import CoreImage

@Model
final class Archer {
    var name: String
    var joinDate: Date
    @Attribute(.externalStorage) var image: Data?
    @Relationship(deleteRule: .cascade, inverse: \Score.archer) var scores = [Score]()
    @Relationship(deleteRule: .cascade, inverse: \AwardStatus.archer) var awardStatuses = [AwardStatus]()
    
    init(name: String, joinDate: Date, image: Data? = nil) {
        self.name = name
        self.joinDate = joinDate
        self.image = image
    }
}
