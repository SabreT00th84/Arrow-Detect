//
//  TargetDetectionCandidate.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 15/12/2025.
//

import Foundation

struct TargetZone {
    
    let confidence: Float
    let label: String
    let boundingBox: CGRect
    var area: CGFloat {
        return boundingBox.width * boundingBox.height
    }
}
