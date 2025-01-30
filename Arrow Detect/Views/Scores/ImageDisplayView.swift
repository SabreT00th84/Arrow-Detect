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
                Button("Score") {
                    viewModel.cropToTarget()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
    }
    
    init (image: CIImage) {
        self.image = image
        self.viewModel = ImageDisplayViewModel(image: image)
    }
}

/*#Preview {
    ImageDisplayView()
}*/
