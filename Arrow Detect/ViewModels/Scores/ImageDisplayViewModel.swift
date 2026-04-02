//
//  ImageDisplayViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 30/01/2025.
//

import Foundation
import CoreGraphics
import CoreImage.CIFilterBuiltins
import Vision

@Observable
final class ImageDisplayViewModel {
    
    var showScoresConfirmation = false
    var isLoading = false
    var errorMessage = ""
    var error: MLError?
    var image: CGImage?
    var annotationsShown = false
    var arrows: [SimpleArrow] = []
    
    init(image: CGImage?) {
        self.image = image
    }
    
    func drawArrowTips (on image: CGImage, with arrows: [SimpleArrow]) async -> CGImage {
        guard let cgContext = CGContext(width: image.width, height: image.height) else { return image }
        
        cgContext.draw(image, in: CGRect(origin: .zero, size: CGSize(width: image.width, height: image.height)))
        cgContext.setLineWidth(2)
        cgContext.setStrokeColor(CGColor(srgbRed: 255, green: 0, blue: 0, alpha: 255))
        for arrow in arrows {
            cgContext.beginPath()
            cgContext.addEllipse(in: CGRect(x: CGFloat(arrow.tip.x), y: CGFloat(arrow.tip.y), width: 5, height: 5))
            cgContext.strokePath()
        }
        
        guard let final = cgContext.makeImage() else { return image }
        return final
    }
    
    func scoreTarget() async {
        
        guard let image else {
            error = .noImage
            return
        }
        
        do {
            let (target, arrowCandidates) = try await detectTargetAndArrows(image: image)
            
            var arrows: [SimpleArrow] = []
            
            for arrow in arrowCandidates {
                let zone = target.first(where: { arrowInEllipse(arrow: arrow, rect: $0.boundingBox) })
                
                if let zone {
                    arrows.append(calculateScore(for: arrow, with: zone, prevZone: zone.label == "Yellow" ? nil : zone))
                } else { //No zones containing the arrow
                    arrows.append(SimpleArrow(tip: Point(x: Float(arrow.tip.x), y: Float(arrow.tip.y)), score: "M")) //Record as a miss
                }
                
            }
            
            guard !arrows.isEmpty else {
                throw MLError.noResults
            }
            self.arrows = arrows
        } catch let error {
            self.error = error as? MLError
        }
    }
    
    private func detectTargetAndArrows(image: CGImage) async throws (MLError) -> ([TargetZone], [ArrowDetectionCandidate])  {
        guard let targetDetector = try? TargetDetector().model,
              let vnTargetModel = try? VNCoreMLModel(for: targetDetector),
              let arrowDetector = try? ArrowDetector().model,
              let vnArrowModel = try? VNCoreMLModel(for: arrowDetector)
        else { throw .modelLoadingFailed }
        
        do {
            let processed = try preProcessImage(image: image)
            let targetRequest = VNCoreMLRequest(model: vnTargetModel)
            let arrowRequest = VNCoreMLRequest(model: vnArrowModel)
            let results = try await performVNRequests(requests: [targetRequest, arrowRequest], on: processed)
            guard let targetObservation = results[0] as? [VNRecognizedObjectObservation],
                  let arrowObservation = (results[1] as? [VNCoreMLFeatureValueObservation])?.first?.featureValue.multiArrayValue
            else { throw MLError.noResults }
            let targetResults = postProcessTarget(results: targetObservation, image: image)
            let arrowResults = postProcessArrows(from: MLShapedArray(arrowObservation), image: image, threshold: 0.7, takeTop: 3)
            
            return (targetResults, arrowResults)
        } catch let error {
            throw error as! MLError
        }
    }
    
    private func arrowInEllipse(arrow: ArrowDetectionCandidate, rect: CGRect) -> Bool {
        let majorRadius = Float(max(rect.width, rect.height) / 2)
        let minorRadius = Float(min(rect.width, rect.height) / 2)
        let center = Point(x: Float(rect.midX), y: Float(rect.midY))
        let xTerm = (pow((Float(arrow.tip.x) - center.x), 2) / pow(majorRadius, 2))
        let yTerm = (pow((Float(arrow.tip.y) - center.y), 2) / pow(minorRadius, 2))
        
        return (xTerm + yTerm) <= 1
    }
    
    private func calculateScore(for arrow: ArrowDetectionCandidate, with zone: TargetZone, prevZone: TargetZone?) -> SimpleArrow {
        if let prevZone {
            let relativeZoneWidth = (zone.boundingBox.width - prevZone.boundingBox.width)
            let relativeZoneHeight = (zone.boundingBox.height - prevZone.boundingBox.height)
            
            let smallerRect = CGRect(origin: zone.boundingBox.origin, size: CGSize(width: (zone.boundingBox.width - (relativeZoneWidth / 2)), height: (zone.boundingBox.height - (relativeZoneHeight / 2))))
            
            let score = getScore(for: zone.label, isHigh: arrowInEllipse(arrow: arrow, rect: smallerRect), isX: false)
            return SimpleArrow(tip: Point(x: Float(arrow.tip.x), y: Float(arrow.tip.y)), score: score)
            
        } else { //Innermost (yellow)
            let tenRect = CGRect(origin: zone.boundingBox.origin, size: CGSize(width: zone.boundingBox.width / 2, height: zone.boundingBox.height / 2))
            let xRect = CGRect(origin: tenRect.origin, size: CGSize(width: tenRect.width / 2, height: tenRect.height / 2))
            
            let score = getScore(for: zone.label, isHigh: arrowInEllipse(arrow: arrow, rect: tenRect), isX: arrowInEllipse(arrow: arrow, rect: xRect))
            return SimpleArrow(tip: Point(x: Float(arrow.tip.x), y: Float(arrow.tip.y)), score: score)
        }
    }
    
    private func getScore(for zone: String, isHigh: Bool, isX: Bool) -> String {
        
        switch zone {
        case "Yellow": return isX ? "X" : isHigh ? "10" : "9"
        case "Red": return isHigh ? "8" : "7"
        case "Blue": return isHigh ? "6" : "5"
        case "Black": return isHigh ? "4" : "3"
        case "White": return isHigh ? "2" : "1"
        default: return "M"
        }
    }
    
    private func preProcessImage (image: CGImage, size: Float = 640)  throws (MLError) -> CGImage {
        
        let originalW: Float = Float(image.width)
        let originalH: Float = Float(image.height)
        
        let scaleFactor = min((size / originalW), (size / originalH))
        let newW = originalW * scaleFactor
        let newH = originalH * scaleFactor
        let paddedX = (size - newW) / 2
        let paddedY = (size - newH) / 2
        
        let cgContext = CGContext(width: Int(size), height: Int(size))
        
        cgContext?.setFillColor(CGColor(srgbRed: 255, green: 255, blue: 255, alpha: 255))
        cgContext?.fill(CGRect(x: 0, y: 0, width: CGFloat(size), height: CGFloat(size)))
        
        cgContext?.draw(image, in: CGRect(x: CGFloat(paddedX), y: CGFloat(paddedY), width: CGFloat(newW), height: CGFloat(newH)))
        
        guard let cgImage = cgContext?.makeImage() else { throw MLError.preProcessingFailed }
        
        return cgImage
    }
    
    private func performVNRequests (requests: [VNRequest], on image: CGImage) async throws (MLError) -> [[VNObservation]] {
        
        let handler = VNImageRequestHandler(cgImage: image, options: [:])
        
        do {
            return try await withCheckedThrowingContinuation { continuation in
                do {
                    try handler.perform(requests)
                    let results = requests.compactMap(\.results)
                    
                    guard results.count > 0 else { throw MLError.noResults }
                    
                    continuation.resume(returning: results)
                    
                } catch let error {
                    continuation.resume(throwing: error)
                }
            }
        } catch {
            throw MLError.noResults
        }
    }
    
    private func postProcessTarget(results: [VNRecognizedObjectObservation], image: CGImage, imgSize: CGFloat = 640) -> [TargetZone] {
        var target: [TargetZone] = []
        
        let processedSize = CGSize(width: Int(imgSize), height: Int(imgSize))
        let originalSize = CGSize(width: image.width, height: image.height)
        let scaleFactor = min((imgSize / originalSize.width), (imgSize / originalSize.height))
        let processedW = originalSize.width * scaleFactor
        let processedH = originalSize.height * scaleFactor
        let paddedX = (imgSize - processedW) / 2
        let paddedY = (imgSize - processedH) / 2
        
        for observation in results.filter({$0.confidence > 0.5}) {
            guard let bestLabel = observation.labels.sorted(by: {$0.confidence > $1.confidence}).first else { continue }
            let processedBox = NormalizedRect(normalizedRect: observation.boundingBox).toImageCoordinates(processedSize)
            let originalBox = CGRect(x: ((processedBox.origin.x - paddedX) / scaleFactor) , y: ((processedBox.origin.y - paddedY) / scaleFactor), width: processedBox.width / scaleFactor, height: processedBox.height / scaleFactor)
            let zone = TargetZone(confidence: bestLabel.confidence, label: bestLabel.identifier, boundingBox: originalBox)
            
            target.append(zone)
        }
        
        return target.sorted(by: {$0.area < $1.area})
    }
    
    private func postProcessArrows(from shaped: MLShapedArray<Float32>, image: CGImage, threshold: Float = 0.5, takeTop maxArrows: Int = 3, imgSize: Float = 640) -> [ArrowDetectionCandidate] {
        
        let noOfDetections = shaped.shape[2]
        
        let originalW: Float = Float(image.width)
        let originalH: Float = Float(image.height)
        let scaleFactor = min((imgSize / originalW), (imgSize / originalH))
        let processedW = originalW * scaleFactor
        let processedH = originalH * scaleFactor
        let paddedX = (imgSize - processedW) / 2
        let paddedY = (imgSize - processedH) / 2
        
        var detectedArrows: [ArrowDetectionCandidate] = []
        
        for detectionIndex in 0 ..< noOfDetections {
            
            let confidence = shaped[0, 4].scalars[detectionIndex]
            
            if confidence >= threshold {
                
                let candidate = ArrowDetectionCandidate(
                    confidence: confidence,
                    box: CGRect(x: CGFloat((shaped[0, 0].scalars[detectionIndex] - paddedX) / scaleFactor),
                                y: CGFloat((shaped[0, 1].scalars[detectionIndex] - paddedY) / scaleFactor),
                                width: CGFloat(shaped[0, 2].scalars[detectionIndex] / scaleFactor),
                                height: CGFloat(shaped[0, 3].scalars[detectionIndex] / scaleFactor)
                               ),
                    tip: CGPoint(x: CGFloat((shaped[0, 5].scalars[detectionIndex] - paddedX) / scaleFactor),
                                 y: CGFloat((shaped[0, 6].scalars[detectionIndex] - paddedY) / scaleFactor)
                                ),
                    nock: CGPoint(x: CGFloat((shaped[0, 8].scalars[detectionIndex] - paddedX) / scaleFactor),
                                  y: CGFloat((shaped[0, 9].scalars[detectionIndex] - paddedY) / scaleFactor)
                                 )
                )
                detectedArrows.append(candidate)
            }
        }
        
        return Array(nmsFilter(detectedArrows, threshold: 0.7).prefix(maxArrows))
   }
    
    private func nmsFilter(_ candidates: [ArrowDetectionCandidate], threshold: Float = 0.5) -> [ArrowDetectionCandidate] {
        guard candidates.count > 1 else { return candidates }
        
        let sorted = candidates.sorted(by: { $0.confidence > $1.confidence })
        var removeIndecies: [Int] = []
        var selected: [ArrowDetectionCandidate] = []
        
        for (i, candidate) in sorted.enumerated() {
            let currentBox = candidate.box
            let currentArea = currentBox.width * currentBox.height
            
            for (j, neighbour) in (sorted[(i+1)...]).enumerated() {
                let neighbourBox = neighbour.box
                let neighboarArea = neighbourBox.width * neighbourBox.height
                let intersectionBox = currentBox.intersection(neighbourBox)
                let intersectionArea = intersectionBox.width * intersectionBox.height
                let unionArea = currentArea + neighboarArea - intersectionArea
                let IoU = intersectionArea / unionArea
                
                if Float(IoU) >= threshold {
                    removeIndecies.append(j)
                }
            }
        }
        
        for (i, candidate) in sorted.enumerated() {
            if !removeIndecies.contains(i) {
                selected.append(candidate)
            }
        }
        
        return selected.sorted(by: {$0.confidence > $1.confidence})
    }
}
