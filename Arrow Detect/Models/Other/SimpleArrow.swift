//
//  SimpleArrow.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 28/12/2025.
//

import Foundation

struct SimpleArrow: Hashable {
    let tip: Point
    var score: String
    
    init(tip: Point, score: String) {
        self.tip = tip
        self.score = score
    }
    
    init (from arrow: Arrow) {
        self.tip = arrow.tip
        self.score = arrow.score
    }
}
