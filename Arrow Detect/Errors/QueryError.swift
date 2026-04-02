//
//  QueryError.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 13/02/2026.
//

import Foundation

enum QueryError: Error {
    
    case retrievalErrorFor(object: String)
    
    var localizedDescription: String {
        switch self {
        case .retrievalErrorFor(object: let object):
            return "Could not retrieve \(object)"
        }
    }
}
