//
//  RootView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 16/08/2025.
//

import SwiftUI
import SwiftData

struct RootView: View {
    
    @Query private var archers: [Archer]
    
    var body: some View {
        if archers.isEmpty {
            SignUpView()
        } else {
            MainTabView()
        }
    }
}

#Preview {
    RootView()
}
