//
//  ScoreSheetView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 20/01/2025.
//

import SwiftUI

struct ScoresheetView: View {
    @State var viewModel =  ScoresheetViewModel()
    @State var showCamera = false
    
    var body: some View {
        Form {
            ForEach (0..<5) { endIndex in
                Section ("End \(endIndex + 1)") {
                    arrowsView(endIndex: endIndex)
                    button
                }
            }
        }
        .fullScreenCover(isPresented: $showCamera) {CameraView()}
    }
    
    @ViewBuilder
    func arrowsView(endIndex: Int) -> some View{
        HStack {
            ForEach (0..<3) { arrowIndex in
                TextField("Arrow \(arrowIndex + 1)", text: $viewModel.scores[endIndex][arrowIndex])
            }
        }
    }
    
    @ViewBuilder
    var button: some View {
        Button("Scan", systemImage: "camera.viewfinder") {
            showCamera = true
        }
    }
}

#Preview {
    ScoresheetView()
}
