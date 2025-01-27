//
//  CameraViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 21/01/2025.
//

import Foundation
import PhotosUI
import SwiftUI
import AVFoundation

class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    
    var imageData: Data?
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error {
            print("Error processing photo: \(error.localizedDescription)")
            return
        } else {
            guard let photoData = photo.fileDataRepresentation() else {
                print("No photo data.")
                return
            }
            imageData = photoData
        }
    }
}

@Observable
class CameraViewModel {
    
    let captureSession = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    var imageItem: PhotosPickerItem?
    var photoData: Data?
    var image: CGImage?
    var showImage = false

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
        guard let videoDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice), captureSession.canAddInput(videoDeviceInput) else { return }
        if captureSession.inputs.isEmpty {
            captureSession.addInput(videoDeviceInput)
        }
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        captureSession.commitConfiguration()
    }
    
    func startCapture () async {
        guard await isAuthorized,
        captureSession.isRunning == false,
        captureSession.inputs.count > 0
        else { return }
            captureSession.startRunning()
    }
    
    func capturePhoto () {
        var photoSettings = AVCapturePhotoSettings()
        if photoOutput.availablePhotoCodecTypes.contains(.hevc) {
            photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
        }
        photoSettings.photoQualityPrioritization = .balanced
        let delegate = PhotoCaptureDelegate()
        photoOutput.capturePhoto(with: photoSettings, delegate: delegate)
        guard let data = delegate.imageData else { return }
        image = convertImage(data: data)
        showImage = true
    }
    
    func convertImage(data: Data) -> CGImage? {
        guard let provider = CGDataProvider(data: data as CFData),
              let image = CGImage(pngDataProviderSource: provider, decode: nil, shouldInterpolate: true, intent: .defaultIntent) else {
            print("Could not create CGImage")
            return nil}
        return image
    }
    
    func stopCapture () {
        guard captureSession.isRunning else { return }
        captureSession.stopRunning()
    }
}
