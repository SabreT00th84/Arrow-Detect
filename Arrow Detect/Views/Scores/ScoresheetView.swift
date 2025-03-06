//
//  ScoreSheetView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 20/01/2025.
//

import SwiftUI

struct ScoresheetView: View {
    @State var viewModel =  ScoresheetViewModel()
    @State var camera = CameraViewModel()
    
    var body: some View {
        VStack {
            Form {
                Picker("Target Size", selection: $viewModel.selectedSize) {
                    Text("80cm").tag(ScoresheetViewModel.TargetSize.eighty)
                    Text("60cm").tag(ScoresheetViewModel.TargetSize.sixty)
                }
                ForEach (0..<5) { endIndex in
                    Section {
                        arrowsView(endIndex: endIndex)
                        button
                    } header: {
                        Text("End \(endIndex + 1)")
                    } footer: {
                        Text("Automatic detection is still in development")
                    }
                }
                HStack {
                    Spacer()
                    Button("Submit") {
                        viewModel.submit()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    Spacer()
                }
            }
            
        }
        //.background(Color.)
        .fullScreenCover(isPresented: $viewModel.showCameraView) {
            if let image = camera.image {
                ImageDisplayView(image: image, targetSize: viewModel.selectedSize)
            } else {
                CameraView(viewModel: $camera)
            }
        }
    }
    
    @ViewBuilder
    func arrowsView(endIndex: Int) -> some View {
        HStack {
            ForEach (0..<3) { arrowIndex in
                TextField("Arrow \(arrowIndex + 1)", text: $viewModel.scores[endIndex][arrowIndex])
                    .textCase(.uppercase)
            }
        }
    }
    
    @ViewBuilder
    var button: some View {
        Button("Scan", systemImage: "camera.viewfinder") {
            viewModel.showCameraView = true
        }
        .disabled(true)
    }
}

#Preview {
    ScoresheetView()
}
