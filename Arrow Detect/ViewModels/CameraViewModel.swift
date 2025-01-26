//
//  CameraViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 21/01/2025.
//

import Foundation
import AVFoundation

class CameraDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error {
            print("Error processing photo: \(error.localizedDescription)")
            return
        }
        
        Task {
            await save(photo: photo)
        }
    }
}


@Observable
class CameraViewModel {
    
    let captureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    private var cameraDelegate: CameraDelegate?
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
    
    init () {
        setupCaptureSession()
    }
    
    private func setupCaptureSession () {
        captureSession.beginConfiguration()
        let videoDevice = AVCaptureDevice.default(for: .video)
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!), captureSession.canAddInput(videoDeviceInput) else { return }
        if captureSession.inputs.isEmpty {
            captureSession.addInput(videoDeviceInput)
        }
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        captureSession.commitConfiguration()
    }
    
    func startCapture () async {
        guard await isAuthorized else { return }
            captureSession.startRunning()
    }
    
    func capturePhoto () {
        var photoSettings = AVCapturePhotoSettings()
        photoSettings.photoQualityPrioritization = .balanced
        //guard let imageData = photoOutput.capturePhoto(with: <#T##AVCapturePhotoSettings#>, delegate: <#T##any AVCapturePhotoCaptureDelegate#>) else { return }
    }
    
    func stopCapture () {
        guard captureSession.isRunning else { return }
        captureSession.stopRunning()
    }
}
