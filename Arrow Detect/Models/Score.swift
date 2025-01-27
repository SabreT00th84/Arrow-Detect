//
//  Item.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 13/10/2024.
//

import Foundation
import SwiftData

@Model
final class Score {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
