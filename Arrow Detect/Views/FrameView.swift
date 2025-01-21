//
//  FrameView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 21/01/2025.
//

import SwiftUI
import AVFoundation
import CoreImage

class FrameHandler: NSObject, ObservableObject {
    @Published var frame: CGImage?
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let context = CIContext()
    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            // Determine if the user previously authorized camera access.
            var isAuthorized = status == .authorized
            
            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            return isAuthorized
        }
    }
        
        override init () {
            super.init()
            sessionQueue.async {
                Task {
                    await self.setupCaptureSession()
                    self.captureSession.startRunning()
                }
            }
        }
    
    func setupCaptureSession () async {
        let videoOutput = AVCaptureVideoDataOutput()
        
        guard await isAuthorized else { return }
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: . back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: device) else { return }
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
        
        videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        captureSession.addOutput(videoOutput)
        videoOutput.connection(with: .video)?.videoRotationAngle = .zero
    }
}

extension FrameHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgimage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
        DispatchQueue.main.async {
            self.frame = cgimage
        }
    }
    
    func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        return cgImage
    }
}


struct FrameView: View {
    
    var image: CGImage?
    private let label = Text("test")
    
    var body: some View {
        if let image {
            Image(image, scale: 1.0, label: label)
        } else {
            Color.black
        }
    }
}

#Preview {
    FrameView()
}
