//
//  MainTabView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 28/12/2024.
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        TabView {
            Tab(content: {ScoresView()}, label: {Label("Scores", systemImage: "chart.bar.xaxis")})
            Tab(content: {AwardsView()}, label: {Label("Awards", systemImage: "medal")})
            Tab(content: {ProfileView()}, label: {Label("Profile", systemImage: "person.crop.circle")})
        }
    }
}

#Preview {
    MainTabView()
}
