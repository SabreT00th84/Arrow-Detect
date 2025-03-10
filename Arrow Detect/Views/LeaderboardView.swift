//
//  LeaderboardView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 28/12/2024.
//

import SwiftUI

struct LeaderboardView: View {
    
    @State var viewModel = LeaderboardViewModel()
    
    var body: some View {
        VStack {
            Picker("Interval", selection: $viewModel.selectedInterval) {
                Text("Weekly").tag(7)
                Text("Monthly").tag(30)
                Text("Yearly").tag(365)
                Text("All-Time").tag(99999999)
            }
            .pickerStyle(.segmented)
            .padding()
            Spacer()
            List {
                loop
            }
        }
        .onChange(of: viewModel.selectedInterval) {
            Task {
                await viewModel.loadTopScores(dayInterval: viewModel.selectedInterval)
            }
        }
    }
    @ViewBuilder
    var loop: some View {
        ForEach(viewModel.topScores, id: \.0?.userId) {(user, score) in
            HStack {
                Text("\(user?.name ?? "")")
                Spacer()
                Text("\(score.scoreTotal)")
            }
        }
    }
}

#Preview {
    LeaderboardView()
}
