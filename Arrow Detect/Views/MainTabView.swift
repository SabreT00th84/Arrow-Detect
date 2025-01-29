//
//  MainTabView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 28/12/2024.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    
    @Environment(\.modelContext) var modelContext
    @State var viewModel = MainTabViewModel()
    @Query private var items: [Score]
    
    var body: some View {
        Group {
            NavigationStack {
                TabView (selection: $viewModel.selection){
                    Tab(value: 0, content: {ScoresView()}, label: {Label("Scores", systemImage: "chart.bar.xaxis")})
                    Tab(value: 1, content: {LeaderboardView()}, label: {Label("Leaderboard", systemImage: "trophy")})
                    Tab(value: 2, content: {InfoView()}, label: {Label("Info", systemImage: "info.circle")})
                    Tab(value: 3, content: {MainSettingsView()}, label: {Label("Settings", systemImage: "gearshape")})
                }
                .navigationDestination(isPresented: $viewModel.showScoresheet, destination: {ScoresheetView()})
                .toolbar {
                    if viewModel.selection == 0 {
                        ToolbarItem {
                         Button(action: addItem) {
                         Label("Add Item", systemImage: "plus")
                            }
                        }
                    }
                }
            }
        }
        .environment(viewModel)
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Score(timestamp: Date())
            modelContext.insert(newItem)
            viewModel.showScoresheet = true
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    MainTabView()
}
