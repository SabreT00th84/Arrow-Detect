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
    
    
    func scoreImage () async -> Arrow {
        return Arrow(arrowId: "", endId: "", x: 0, y: 0, score: 0)
    }
}

/*#Preview {
    ImageDisplayView()
}*/
