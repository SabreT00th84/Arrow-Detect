//
//  CentraliseView.swift
//  ArrowDetectOffline
//
//  Created by Eesa Adam on 26/01/2026.
//

import SwiftUI

struct CentralisedStack<Content: View>: View {
    
    enum Orientation {
        case horizontal
        case vertical
    }
    
    let orientation: Orientation
    @ViewBuilder var content: Content
    
    var body: some View {
        switch orientation {
        case .horizontal: centraliseHorizontal
        case .vertical: centralisedVertical
        }
    }
    
    @ViewBuilder
    private var centralisedContent: some View {
        Spacer()
        content
        Spacer()
    }
    
    @ViewBuilder
    private var centraliseHorizontal: some View {
        HStack {
            centralisedContent
        }
    }
    
    @ViewBuilder
    private var centralisedVertical: some View {
        VStack {
            centralisedContent
        }
    }
}
