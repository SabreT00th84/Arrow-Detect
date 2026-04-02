//
//  End.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 06/03/2025.
//

import Foundation
import SwiftData
import CoreImage

@Model
final class End {
    @Relationship(deleteRule: .nullify) var score: Score?
    var endNo: Int
    var endTotal: Int
    var image: Data?
    @Relationship(deleteRule: .cascade, inverse: \Arrow.end) var arrows = [Arrow]()
    
    init(score: Score, endNo: Int, endTotal: Int, image: Data? = nil) {
        self.score = score
        self.endNo = endNo
        self.endTotal = endTotal
        self.image = image
    }
}
