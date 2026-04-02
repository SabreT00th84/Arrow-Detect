//
//  InputError.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 13/02/2026.
//

import Foundation

enum ValidationError: Error {
    case emptyFields
    case invalidScore
    case tooFewPoints
    
    var localizedDescription: String {
        switch self {
        case .emptyFields:
            return "Please fill in all fields"
        case .tooFewPoints:
            return "3 points are required to calculate the radius"
        case .invalidScore:
            return "Please ensure you only enter numbers between 1-10, an X or M"
        }
    }
}
