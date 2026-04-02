//
//  ImageDisplayView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 27/01/2025.
//

import SwiftUI

struct ImageDisplayView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var end: SimpleEnd
    @State private var viewModel: ImageDisplayViewModel
    
    init (end: Binding<SimpleEnd>) {
        self._end = end
        self.viewModel = ImageDisplayViewModel(image: end.wrappedValue.image)
    }
    
    var body: some View {
        if let image = viewModel.image {
            VStack {
                targetImage(image)
                scoreButtonAndAlert
                if end.arrows.filter({$0.score != ""}).isEmpty {
                    scoreButtonAndAlert
                } else if viewModel.annotationsShown {
                    hideAnnotationsButton
                } else {
                    showAnnotationsButton(image: image)
                }
            }
        } else {
            Text("No Image")
                .bold()
                .foregroundStyle(Color.red)
        }
    }
    
    @ViewBuilder
    private var scoreButtonAndAlert: some View {
        if end.arrows.filter({$0.score != ""}).isEmpty {
            Button("Score") {
                viewModel.isLoading = true
                Task {
                    await viewModel.scoreTarget()
                    viewModel.isLoading = false
                    viewModel.showScoresConfirmation = true
                }
            }
            .alert("Arrows Detected", isPresented: $viewModel.showScoresConfirmation) {
                if !viewModel.errorMessage.isEmpty {
                    
                    Button("OK", role: .close) {}
                } else {
                    
                    Button("Accept", role: .confirm) {
                        end.arrows = viewModel.arrows
                        dismiss()
                    }
                    .keyboardShortcut(.defaultAction)
                    Button("Reject", role: .cancel) {}
                }
            } message: {
                let message = !viewModel.arrows.isEmpty ? "The AI has detected arrows with scores \(viewModel.arrows.map(\.score).prefix(viewModel.arrows.endIndex - 1).joined(separator: ", ")) and \(viewModel.arrows.last!.score). You can always edit the scores later." : viewModel.errorMessage
                Text(message)
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 50)
        }
    }
    
    @ViewBuilder
    private var hideAnnotationsButton: some View {
        Button("Hide Detections") {
            viewModel.image = end.image
            viewModel.annotationsShown = false
        }
    }
    
    @ViewBuilder
    private func targetImage(_ image: CGImage) -> some View {
        Image(image, scale: 1, label: Text("Target Image"))
            .resizable()
            .scaledToFit()
            .padding()
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(2)
                }
            }
    }
    
    @ViewBuilder
    private func showAnnotationsButton(image: CGImage) -> some View {
        Button("Show Detections") {
            viewModel.isLoading = true
            Task {
                viewModel.image = await viewModel.drawArrowTips(on: image, with: end.arrows)
                viewModel.isLoading = false
                viewModel.annotationsShown = true
            }
        }
    }
}
