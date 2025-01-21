//
//  CameraView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 20/01/2025.
//

import SwiftUI

struct CameraView: View {
    
    @StateObject private var model = FrameHandler()
    
    var body: some View {
        FrameView(image: model.frame)
            .ignoresSafeArea()
    }
}

#Preview {
    CameraView()
}
