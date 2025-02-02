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
    @ObservationIgnored private var quadDetectRequest: VNDetectRectanglesRequest {
        let request = VNDetectRectanglesRequest(completionHandler: self.quadPostProcess)
        request.maximumObservations = 1
        request.minimumSize = 0.4
        request.minimumConfidence = 0.8
        request.quadratureTolerance = 10
        return request
    }
    
    init(image: CIImage) {
        self.image = image
    }
    
    private func correctPerspective(ciImage: CIImage, rectangle: VNRectangleObservation) -> CIImage? {
        let filter = CIFilter.perspectiveCorrection()
        let width = ciImage.extent.width
        let height = ciImage.extent.height
        
        filter.inputImage = ciImage
        filter.topLeft = CGPoint(x: rectangle.topLeft.x * width, y: rectangle.topLeft.y * height)
        filter.topRight = CGPoint(x: rectangle.topRight.x * width, y: rectangle.topRight.y * height)
        filter.bottomLeft = CGPoint(x: rectangle.bottomLeft.x * width, y: rectangle.bottomLeft.y * height)
        filter.bottomRight = CGPoint(x: rectangle.bottomRight.x * width, y: rectangle.bottomRight.y * height)
        return filter.outputImage
    }
    
    private func quadPostProcess(request: VNRequest?, error: Error?){
        if let error {
            print(error)
            return
        } else if let result = request?.results?.first as? VNRectangleObservation {
            guard let correctedImage = correctPerspective(ciImage: image, rectangle: result) else {
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
