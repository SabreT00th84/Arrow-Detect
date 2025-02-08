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
        request.minimumSize = 0.3
        request.minimumConfidence = 0.5
        request.quadratureTolerance = 40
        return request
    }
    
    @ObservationIgnored private var contourDetectRequest: VNDetectContoursRequest {
        let request = VNDetectContoursRequest(completionHandler: self.contourPostProcess)
        request.contrastAdjustment = 0.3
        //request.detectsDarkOnLight = true
        return request
    }
    init(image: CIImage) {
        self.image = image
    }
    
    private func preProcess(ciImage: CIImage, rectangle: VNRectangleObservation) -> CIImage? {
        let filter = CIFilter.perspectiveCorrection()
        let width = ciImage.extent.width
        let height = ciImage.extent.height
        let edgesFilter = CIFilter.cannyEdgeDetector()
        
        filter.inputImage = ciImage
        filter.topLeft = CGPoint(x: rectangle.topLeft.x * width, y: rectangle.topLeft.y * height)
        filter.topRight = CGPoint(x: rectangle.topRight.x * width, y: rectangle.topRight.y * height)
        filter.bottomLeft = CGPoint(x: rectangle.bottomLeft.x * width, y: rectangle.bottomLeft.y * height)
        filter.bottomRight = CGPoint(x: rectangle.bottomRight.x * width, y: rectangle.bottomRight.y * height)
        edgesFilter.inputImage = filter.outputImage
        edgesFilter.gaussianSigma = 4.5
        //edgesFilter.setValue(40.0, forKey: kCIInputIntensityKey) // Adjust intensity
        return edgesFilter.outputImage
    }
    
    private func quadPostProcess(request: VNRequest?, error: Error?){
        if let error {
            print(error)
            return
        } else if let result = request?.results?.first as? VNRectangleObservation {
            guard let processedImage = preProcess(ciImage: image, rectangle: result) else {
                print("could not unskew image perspective")
                return
            }
            image = processedImage
            let handler = VNImageRequestHandler(ciImage: image, options: [:])
            do {
                try handler.perform([contourDetectRequest])
            } catch {
                print("contours error")
            }
        } else {
            print("no data")
        }
    }
    
    private func contourPostProcess (request: VNRequest?, error: Error?) {
        guard let result = request?.results?.first as? VNContoursObservation else {
            print("No contours detected")
            return
        }
        guard let annotated = drawContours(on: image, contours: result.topLevelContours.compactMap({$0}), imageSize: image.extent.size) else { return}
        image = annotated
    }
    
    func drawContours(on ciImage: CIImage, contours: [VNContour], imageSize: CGSize) -> CIImage? {
        let format = CIFormat.RGBA8
        let context = CIContext(options: nil)
        
        // Create CGImage from CIImage
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }

        let renderer = UIGraphicsImageRenderer(size: imageSize)
        let annotatedImage = renderer.image { ctx in
            // Draw original image
            ctx.cgContext.draw(cgImage, in: CGRect(origin: .zero, size: imageSize))
            
            // Set contour drawing properties
            ctx.cgContext.setStrokeColor(UIColor.red.cgColor)
            ctx.cgContext.setLineWidth(2)

            for contour in contours {
                let points = contour.normalizedPoints.map { point in
                    CGPoint(x: CGFloat(point.x * Float(imageSize.width)), y: CGFloat((point.y) * Float(imageSize.height)))
                }
                
                if let firstPoint = points.first {
                    ctx.cgContext.move(to: firstPoint)
                    for point in points.dropFirst() {
                        ctx.cgContext.addLine(to: point)
                    }
                    ctx.cgContext.closePath()
                }
            }
            ctx.cgContext.strokePath()
        }

        return CIImage(image: annotatedImage)
    }
    
    func score() async {
        do {
            let handler = VNImageRequestHandler(ciImage: image, options: [:])
            
            try handler.perform([quadDetectRequest])

        } catch let error {
            print(error)
        }
    }
}
