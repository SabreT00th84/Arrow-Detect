//
//  ImageDisplayView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 27/01/2025.
//

import SwiftUI

struct ImageDisplayView: View {
    
    let image: CGImage
    
    var body: some View {
        ZStack (alignment: .bottom) {
            Image(image, scale: 1, label: Text("Target Image"))
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
            Button("Score") {
                DispatchQueue.global().async {
                    Task {
                        await scoreImage()
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }
    
    func scoreImage () async -> Arrow {
        return Arrow(arrowId: "", endId: "", x: 0, y: 0, score: 0)
    }
}

/*#Preview {
    ImageDisplayView()
}*/
