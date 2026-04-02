//
//  SimpleEnd.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 28/12/2025.
//

import Foundation
import CoreGraphics.CGImage

struct SimpleEnd: Hashable {
    var image: CGImage?
    var arrows: [SimpleArrow]
    
    init(image: CGImage? = nil, arrows: [SimpleArrow]) {
        self.image = image
        self.arrows = arrows
    }
    
    init (from end: End) {
        self.image = end.image?.createCGImage()
        self.arrows = end.arrows.map { SimpleArrow(from: $0) }
    }
}
