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
    @ObservationIgnored private var quadDetectRequest: VNDetectDocumentSegmentationRequest {
        return VNDetectDocumentSegmentationRequest(completionHandler: self.quadPostProcess)
    }
    
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
    
    private func quadPostProcess(request: VNRequest?, error: Error?){
        if let error {
            print(error)
            return
        } else if let result = request?.results?.first as? VNRectangleObservation {
            guard let correctedImage = correctPerspective(ciImage: image, topLeft: result.topLeft, topRight: result.topRight, bottomLeft: result.bottomLeft, bottomRight: result.bottomRight) else {
                print("could not unskew image perspective")
                return
            }
            image = correctedImage
        } else {
            print("no data")
        }
    }
    
    func cropToTarget() async {
        do {
            let handler = VNImageRequestHandler(ciImage: image, options: [:])
            
            try handler.perform([quadDetectRequest])
            
            /*guard let results = quadDetectRequest.results?.first else {
                print("No results")
                return
            }
            guard let correctedImage = correctPerspective(ciImage: image, topLeft: results.topLeft, topRight: results.topRight, bottomLeft: results.bottomLeft, bottomRight: results.bottomRight) else {
                print("Could not unskew image perspective")
                return
            }
            image = correctedImage*/

        } catch let error {
            print(error)
        }
    }
}
