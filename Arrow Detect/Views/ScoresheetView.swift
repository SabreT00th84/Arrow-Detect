//
//  ScoreSheetView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 20/01/2025.
//

import SwiftUI

struct ScoresheetView: View {
    @StateObject var viewModel =  ScoresheetViewModel()
    
    var body: some View {
        Form {
            ForEach (0..<5) { endIndex in
                Section ("End \(endIndex + 1)") {
                    HStack {
                        ForEach (0..<3) { arrowIndex in
                            TextField("Arrow \(arrowIndex + 1)", text: $viewModel.scores[endIndex][arrowIndex])
                        }
                    }
                    button
                }
            }
        }
    }
    
    var button: some View {
        NavigationLink(destination: CameraView()) {
            Label("Scan", systemImage: "camera.viewfinder")
        }
    }
}

#Preview {
    ScoresheetView()
}
