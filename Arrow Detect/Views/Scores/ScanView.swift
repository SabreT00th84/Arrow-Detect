//
//  SwitchCameraImageView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 25/11/2025.
//

import SwiftUI

struct ScanView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var end: SimpleEnd
    
    var body: some View {
        NavigationStack {
            Group {
                if end.image != nil {
                    ImageDisplayView(end: $end)
                } else {
                    CameraView(image: $end.image)
                }
            }
            .navigationTitle("Scan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
                if end.image != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(role: .destructive) {
                            end.image = nil
                            end.arrows = Array(repeating: SimpleArrow(tip: Point(x: 0, y: 0), score: ""), count: 3)
                        }
                    }
                }
            }
        }
    }
}
