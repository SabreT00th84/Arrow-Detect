//
//  ContentView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 13/10/2024.
//

import SwiftUI
import SwiftData


enum ScoresDestinations: Hashable {
    
    case scoresheet
    case stat(score: Score)
    case image(end: SimpleEnd)
    
    var title: String {
        switch self {
        case .scoresheet: return "Scoresheet"
        case .stat(let score): return score.date.formatted(date: .numeric, time: .shortened)
        case .image(_): return "Image"
        }
    }
}

struct ScoresView: View {
    
    @Environment(\.modelContext) private var context
    @State private var path = NavigationPath()
    @Query private var scores: [Score]
    
    var body: some View {
        NavigationStack (path: $path) {
            List {
                ForEach(scores.sorted {$0.date > $1.date}) { score in
                    NavigationLink (value: ScoresDestinations.stat(score: score)) {
                        Text(score.date.formatted(date: .abbreviated, time: .shortened))
                    }
                }
                .onDelete(perform: deleteScores)
            }
            .navigationTitle("Scores")
            .navigationDestination(for: ScoresDestinations.self) { scoreDestination in
                Group {
                    switch scoreDestination {
                    case .scoresheet:
                        ScoresheetView(path: $path)
                    case .stat(let score):
                        StatsView(path: $path, score: score)
                    case .image(end: let end):
                        ImageDisplayView(end: .constant(end))
                    }
                }
                .navigationTitle(scoreDestination.title)
                .navigationBarTitleDisplayMode(.inline)
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        path.append(ScoresDestinations.scoresheet)
                    } label: {
                 Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    EditButton()
                }
            }
        }
    }
    
    // MARK: - SwiftData
    private func deleteScores (at offsets: IndexSet) {
        for offset in offsets {
            let score = scores[offset]
            context.delete(score)
        }
    }
}
