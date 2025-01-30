//
//  ImageDisplayViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 30/01/2025.
//

import Foundation
import Vision
import VisionKit
import CoreImage
import CoreImage.CIFilterBuiltins

@Observable
class ImageDisplayViewModel {
    
    var image: CIImage
    //@ObservationIgnored private
    
    init(image: CIImage) {
        self.image = image
    }
    
    private func correctPerspective(ciImage: CIImage, topLeft:CGPoint, topRight:CGPoint, bottomLeft:CGPoint, bottomRight:CGPoint) -> CIImage? {
        let filter = CIFilter.perspectiveCorrection()
        filter.inputImage = ciImage
        filter.topLeft = topLeft
        filter.topRight = topRight
        filter.bottomLeft = bottomLeft
        filter.bottomRight = bottomRight
        return filter.outputImage
    }
    
    func cropToTarget() {
        do {
            let handler = VNImageRequestHandler(ciImage: image, options: [:])
            var quadDetectRequest: VNDetectDocumentSegmentationRequest {
                return VNDetectDocumentSegmentationRequest()
            }
            
            try handler.perform([quadDetectRequest])
            
            guard let results = quadDetectRequest.results?.first else {
                print("No results")
                return
            }
            guard let correctedImage = correctPerspective(ciImage: image, topLeft: results.topLeft, topRight: results.topRight, bottomLeft: results.bottomLeft, bottomRight: results.bottomRight) else {
                print("Could not unskew image perspective")
                return
            }
            image = correctedImage
        } catch let error {
            print(error)
        }
    }
}
