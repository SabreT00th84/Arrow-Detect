//
//  CameraError.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 23/02/2026.
//

import Foundation

enum CameraError: Error {
    
    case noVideoDevice
    case noOutputChannel
    case notAuthorised
    case postProcessingFailed
    case conversionError
    
    var message: String {
        switch self {
        case .noVideoDevice:
            return "No video device found"
        case .noOutputChannel:
            return "No output channel found"
        case .notAuthorised:
            return "Not authorised to access camera"
        case .postProcessingFailed:
            return "Post processing failed"
        case .conversionError:
            return "Failed to convert image"
        }
    }
}
