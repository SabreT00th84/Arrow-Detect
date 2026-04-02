//
//  Extensions.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 26/12/2024.
//

import Foundation
import SwiftUI
import AVFoundation
import UniformTypeIdentifiers

extension CGImage {
    var jpegData: Data? {
        guard let mutableData = CFDataCreateMutable(nil, 0),
              let destination = CGImageDestinationCreateWithData(mutableData, "public.jpeg" as CFString, 1, nil)
        else {
            return nil
        }
        CGImageDestinationAddImage(destination, self, nil)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return mutableData as Data
    }
}

extension Data {
    func createCGImage () -> CGImage? {
        
        guard let ciImage = CIImage(data: self) else { return nil }
        
        return CIContext().createCGImage(ciImage, from: ciImage.extent)
        
    }
}

@globalActor actor CameraActor: GlobalActor {
    static let shared = CameraActor()
}
