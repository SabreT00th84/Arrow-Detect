//
//  StatsView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 08/03/2025.
//

import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    
    @Binding var path: NavigationPath
    let score: Score
    private let columns = Array(repeating: GridItem(.fixed(55), alignment: .center), count: 5)
    
    var body: some View {
        List {
            Section {
                tableHeaders(columns: columns)
                tableContent(columns: columns)
            } header: {
                sessionInfo
            } footer: {
                sessionStats(for: score.stat)
            }
        }
    }
    
    private var twoDPFormat: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    private var percentFormat: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .percent
        return formatter
    }
    
    @ViewBuilder
    private var sessionInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("**Bow type:** \(score.bowType)")
            Text("**Distance:** \(score.distance)m")
            Text("**Target Size:** \(score.targetSize)cm")
        }
        .foregroundStyle(.primary)
        .font(.body)
    }
    
    @ViewBuilder
    private func tableHeaders(_ headers: [String] = ["End", "Arrow 1", "Arrow 2", "Arrow 3", "Total"], columns: [GridItem]) -> some View {
        LazyVGrid(columns: columns, spacing: 5) {
            ForEach(headers, id: \.self) { header in
                Text(header)
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.trailing, 35)
    }
    
    @ViewBuilder
    private func tableContent(columns: [GridItem]) -> some View {
        ForEach(score.ends.sorted {$0.endNo < $1.endNo}) { end in
            NavigationLink (value: ScoresDestinations.image(end: SimpleEnd(from: end))){
                LazyVGrid(columns: columns, spacing: 5) {
                    Text(String(end.endNo))
                    ForEach(end.arrows) { arrow in
                        Text(arrow.score)
                    }
                    Text(String(end.endTotal))
                }
            }
        }
    }
    
    @ViewBuilder
    func sessionStats(for stat: Stat?) -> some View {
        if let stat {
            VStack {
                Text("Grand Total: \(score.scoreTotal)")
                    .font(.headline)
                Text("**Average Score:** \(twoDPFormat.string(for: stat.avgScore) ?? "")")
                Text("Arrow Distibution")
                    .font(.title)
                arrowPieChart(noOfScoresEach: stat.noOfScoresEach)
                Text("**Performance Score:** \(twoDPFormat.string(for: stat.perfScore) ?? "")")
                Text("**Performance Improvement:** \(percentFormat.string(for: stat.perfImprovement) ?? "")")
            }
            .foregroundStyle(.primary)
            .font(.body)
        }
    }
    
    @ViewBuilder
    func arrowPieChart(noOfScoresEach: [Int]) -> some View {
        Chart {
            ForEach(noOfScoresEach.indices, id: \.self) { index in
                SectorMark(angle: .value(scoreForIndex(index), noOfScoresEach[index]), angularInset: 2)
                    .foregroundStyle(colorForIndex(index))
                    .cornerRadius(6)
                    .annotation(position: .overlay) {
                        if noOfScoresEach[index] > 0 {
                            Text(scoreForIndex(index))
                                .foregroundStyle(.white)
                        }
                    }
            }
        }
        .padding()
        .scaledToFit()
    }
    
    // MARK: - View helper functions
    
    func scoreForIndex(_ index: Int) -> String {
        if index == 0 {
            return "M"
        } else if index == 11 {
            return "X"
        } else {
            return String(index)
        }
    }
    
    func colorForIndex(_ index: Int) -> Color {
        if index >= 9 {
            return .yellow
        } else if index >= 7 {
            return .red
        } else if index >= 5 {
            return .blue
        } else if index >= 3 {
            return .black
        } else {
            return .gray
        }
    }
}
