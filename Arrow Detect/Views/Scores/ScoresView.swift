//
//  ContentView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 13/10/2024.
//

import SwiftUI

struct ScoresView: View {
    @Environment(MainTabViewModel.self) var tabViewModel
    @State private var viewModel = ScoresViewModel()
    @State private var scores: [Score] = []
    
    var body: some View {
        List {
            ForEach(scores, id: \.scoreId) { score in
                NavigationLink {
                    StatsView(score: score)
                } label: {
                    Text(score.date.formatted(date: .abbreviated, time: .shortened))
                }
            }
            .onDelete(perform: deleteScores)
        }
        .task {
            self.scores = await viewModel.loadScores()
            print("task completed")
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ScoresheetSubmitted"))) { notification in
            Task {@MainActor in
                if let object = notification.userInfo?["record"] as? Score {
                    withAnimation {
                        self.scores.append(object)
                    }
                } else {
                    self.scores = await viewModel.loadScores()
                }
            }
        }
    }
    
    func deleteScores (offsets: IndexSet) {
        let idsToDelete = offsets.map { scores[$0].scoreId }
        Task {
            do {
                try await viewModel.deleteRecords(scoreIds: idsToDelete)
                await MainActor.run {
                    scores.remove(atOffsets: offsets)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ScoresView()
}
