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
    
    let completion: (Result<Data, Error>) -> Void
    
    init(completion: @escaping (Result<Data, Error>) -> Void) {
        self.completion = completion
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error {
            completion(.failure(error))
            return
        } else if let photoData = photo.fileDataRepresentation() {
            completion(.success(photoData))
        } else {
            completion(.failure(NSError(domain: "photoOutput()", code: -1, userInfo: ["localizedDescription": "Could not get image data"])))
        }
    }
}

@Observable
final class CameraController {
    
    private let photoOutput = AVCapturePhotoOutput()
    let captureSession = AVCaptureSession()
    private var delegate: PhotoCaptureDelegate?
    var imageItem: PhotosPickerItem?
    var error: CameraError?

    @ObservationIgnored private var isAuthorized: Bool {
        //Pasted from Apple Developer Documentation
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        // Determine if the user previously authorized camera access.
        var isAuthorized = status == .authorized
        
        // If the system hasn't determined the user's authorization status,
        // explicitly prompt them for approval.
        if status == .notDetermined {
            Task {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
        }
        
        return isAuthorized
    }
    
    init () {
        do {
            try setupCaptureSession()
        } catch let error {
            self.error = error
        }
    }
    
    private func setupCaptureSession() throws (CameraError) {
        captureSession.beginConfiguration()
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              captureSession.canAddInput(videoDeviceInput)
        else { throw .noVideoDevice }
        if captureSession.inputs.isEmpty {
            captureSession.addInput(videoDeviceInput)
        }
        guard captureSession.canAddOutput(photoOutput) else { throw .noOutputChannel }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        captureSession.commitConfiguration()
    }
    
    @CameraActor
    func startCapture() async throws (CameraError) {
        guard isAuthorized,
        captureSession.isRunning == false,
        captureSession.inputs.count > 0
        else { throw .notAuthorised }
            captureSession.startRunning()
    }
    
    @CameraActor
    private func captureImage() async throws(CameraError) -> Data {
        var photoSettings = AVCapturePhotoSettings()
        if photoOutput.availablePhotoCodecTypes.contains(.jpeg) {
            photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        }
        photoSettings.photoQualityPrioritization = .balanced
        
        do {
            return try await withCheckedThrowingContinuation { continuation in
                let delegate = PhotoCaptureDelegate { result in
                    switch result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
                self.delegate = delegate
                photoOutput.capturePhoto(with: photoSettings, delegate: delegate)
            }
        } catch {
            throw .postProcessingFailed
        }
    }
    
    @CameraActor
    func getImage() async throws(CameraError) -> CGImage {
        self.delegate = nil
        do {
            let data = try await captureImage()
            guard let image = data.createCGImage() else { throw CameraError.conversionError }
            return image
        } catch let error {
            throw error as! CameraError
        }
    }
    
    func stopCapture() {
        guard captureSession.isRunning else { return }
        self.captureSession.stopRunning()
    }
}
