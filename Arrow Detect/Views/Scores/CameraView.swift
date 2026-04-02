//
//  CameraView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 20/01/2025.
//

import SwiftUI
import PhotosUI
import AVFoundation

class CameraUIView: UIView {
    
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
}

struct CameraViewRepresentable: UIViewRepresentable {
    
    let cameraController: CameraController
    
    func makeUIView(context: Context) -> CameraUIView {
        DispatchQueue.main.async {
            Task {
                do {
                    try await cameraController.startCapture()
                } catch let error {
                    cameraController.error = error as? CameraError
                }
            }
        }
        let view = CameraUIView()
        view.backgroundColor = .black
        view.previewLayer.session = cameraController.captureSession
        view.previewLayer.videoGravity = .resizeAspect
        view.previewLayer.connection?.videoRotationAngle = 90
        return view
    }
    
    func updateUIView (_ UIView: CameraUIView, context: Context) {}
}


struct CameraView: View {
    
    @Binding var image: CGImage?
    @State private var camera = CameraController()
    
    var body: some View {
        if let error = camera.error {
            Text(error.message)
                .bold()
                .foregroundStyle(.red)
        } else {
            cameraView
        }
    }
    
    @ViewBuilder
    private var cameraView: some View {
        ZStack(alignment: .bottomLeading) {
            CameraViewRepresentable(cameraController: camera)
                .ignoresSafeArea()
            cameraToolbar
        }
        .onDisappear {
            camera.stopCapture()
        }
    }
    
    @ViewBuilder
    private var cameraToolbar: some View {
        HStack (alignment: .center) {
            imageWell
            captureButton
        }
        .background(.black)
    }
    
    @ViewBuilder
    private var imageWell: some View {
        PhotosPicker(selection: $camera.imageItem, matching: .images, photoLibrary: .shared()) {
                Circle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(width: 50, height: 50, alignment: .leading)
                    .padding()
            }
            .onChange(of: camera.imageItem) {
                Task {
                    guard let photoData = try? await camera.imageItem?.loadTransferable(type: Data.self),
                          let ciImage = CIImage(data: photoData),
                          let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else { return }
                    self.image = cgImage
                }
            }
    }
    
    @ViewBuilder
    private var captureButton: some View {
        Spacer()
        ZStack (alignment: .center) {
            Circle()
                .frame(width: 70, height: 70, alignment: .center)
                .glassEffect(.regular)
            Button() {
                Task {
                    do {
                        self.image = try await camera.getImage()
                    } catch let error {
                        camera.error = error as? CameraError
                    }
                }
            } label: {
                Circle()
                    .fill(.white)
                    .frame(width: 60, height: 60, alignment: .center)
            }
            .padding()
        }
        Spacer(minLength: 135)
    }
}
