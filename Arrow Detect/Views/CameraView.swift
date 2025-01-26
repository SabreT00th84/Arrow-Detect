//
//  CameraView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 20/01/2025.
//

import SwiftUI

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
    
    let model: CameraViewModel
    
    func makeUIView(context: Context) -> CameraUIView {
        DispatchQueue.main.async {
            Task {
                await model.startCapture()
            }
        }
        let view = CameraUIView()
        view.backgroundColor = .black
        view.previewLayer.session = model.captureSession
        view.previewLayer.videoGravity = .resizeAspect
        view.previewLayer.connection?.videoRotationAngle = 90
        return view
    }
    
    func updateUIView (_ UIView: CameraUIView, context: Context) {}
}


struct CameraView: View {
    
    @State private var viewModel = CameraViewModel()
    
    var body: some View {
        VStack {
            CameraViewRepresentable(model: viewModel)
                .ignoresSafeArea()
            HStack {
                //PhotoThumbnail()
                Spacer()
                Button(action: {viewModel.stopCapture()}) {
                    Circle()
                        .foregroundStyle(Color.white)
                        .frame(width: 70, height: 70, alignment: .center)
                        .overlay {
                            Circle()
                                .stroke(Color.black.opacity(0.8), lineWidth: 2)
                                .frame(width: 59, height: 59, alignment: .center)
                        }
                }
                .padding()
                Spacer()
            }
            .background(Color.black)
        }
        .task {
            await viewModel.startCapture()
        }
        .onDisappear {
            viewModel.stopCapture()
        }
    }
}

#Preview {
    CameraView()
}
