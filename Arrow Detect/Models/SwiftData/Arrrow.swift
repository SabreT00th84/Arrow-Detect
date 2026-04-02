//
//  Arrrow.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 27/01/2025.
//

import Foundation
import SwiftData

@Model
final class Arrow {
    @Relationship(deleteRule: .nullify) var end: End?
    var arrowNo: Int
    var tip: Point
    var score: String
    
    init(end: End, arrowNo: Int, tip: Point, score: String) {
        self.end = end
        self.arrowNo = arrowNo
        self.tip = tip
        self.score = score
    }
}
