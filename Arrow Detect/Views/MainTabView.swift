//
//  MainTabView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 28/12/2024.
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        NavigationStack {
            TabView {
                Tab(content: {ScoresView()}, label: {Label("Scores", systemImage: "chart.bar.xaxis")})
                Tab(content: {LeaderboardView()}, label: {Label("Leaderboard", systemImage: "trophy")})
                Tab(content: {InfoView()}, label: {Label("Info", systemImage: "info.circle")})
                Tab(content: {MainSettingsView()}, label: {Label("Settings", systemImage: "gearshape")})
            }
        }
    }
}

#Preview {
    MainTabView()
}
