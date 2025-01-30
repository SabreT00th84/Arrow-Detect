//
//  ImageDisplayView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 27/01/2025.
//

import SwiftUI

struct ImageDisplayView: View {
    
    let image: CIImage
    @State var viewModel: ImageDisplayViewModel
    
    var body: some View {
        ZStack (alignment: .bottom) {
            if let cgImage = CIContext().createCGImage(viewModel.image, from: viewModel.image.extent) {
                Image(cgImage, scale: 1, label: Text("Target Image"))
                    .resizable()
                    .scaledToFill()
                    .rotationEffect(Angle(degrees: 90))
                Button("Score") {
                    Task {
                        await scoreImage()
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .task {
            viewModel = ImageDisplayViewModel(image: image)
        }
    }
    
    
    func scoreImage () async -> Arrow {
        return Arrow(arrowId: "", endId: "", x: 0, y: 0, score: 0)
    }
}

/*#Preview {
    ImageDisplayView()
}*/
