//
//  MLError.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 23/02/2026.
//

import Foundation

enum MLError: Error {
    case noImage
    case noResults
    case preProcessingFailed
    case modelLoadingFailed
    
    var localizedDescription: String {
        switch self {
        case .noImage:
            return "Failed to find image. Please try again."
        case .noResults:
            return "No results found. Please try again."
        case .preProcessingFailed:
            return "Failed to process image. Please try again."
        case .modelLoadingFailed:
            return "Failed to load model. Please try again."
        }
    }
}
