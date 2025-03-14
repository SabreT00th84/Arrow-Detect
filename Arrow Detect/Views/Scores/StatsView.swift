//
//  StatsView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 08/03/2025.
//

import SwiftUI
import Charts

struct StatsView: View {
    
    @State var viewModel: StatsViewModel
    var twoDPFormat: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }
    var percentFormat: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .percent
        return formatter
    }
    
    var body: some View {
        let headers = ["End", "Arrow 1", "Arrow 2", "Arrow 3", "End Total"]
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 8) {
                Text("**Verified:** \(viewModel.verification)")
                Text("**Bow type:** \(viewModel.score.bowType)")
                Text("**Distance:** \(viewModel.score.distance)")
                Text("**Target Size:** \(viewModel.score.targetSize)")
            }
            LazyHGrid(rows: [GridItem(.fixed(50), alignment: .center)], spacing: 10) {
                ForEach(headers, id: \.self) {header in
                        Text(header)
                        .font(.headline)
                }
            }
            ForEach(viewModel.tableData) {row in
                LazyHGrid(rows: [GridItem(.fixed(10))], spacing: 60) {
                    Text(row.endNo)
                    Text(row.arrow1)
                    Text(row.arrow2)
                    Text(row.arrow3)
                    Text(row.endTotal)
                }
            }
            Text("Grand Total: \(viewModel.score.scoreTotal)")
                .font(.headline)
            if let stat = viewModel.stat {
                Text("**Average Score:** \(twoDPFormat.string(for: stat.avgScore) ?? "")")
                Text("Arrow Distibution")
                    .font(.title)
                Chart {
                    SectorMark(angle: .value("X", stat.noOfX), angularInset: 2)
                        .foregroundStyle(.yellow)
                        .cornerRadius(6)
                        .annotation(position: .overlay) {
                            if stat.noOfX > 0 {
                                Text("X")
                            }
                        }
                    SectorMark(angle: .value("10", stat.noOf10), angularInset: 2)
                        .foregroundStyle(.yellow)
                        .cornerRadius(6)
                        .annotation(position: .overlay) {
                            if stat.noOf10 > 0 {
                                Text("10")
                            }
                        }
                    SectorMark(angle: .value("9", stat.noOf9), angularInset: 2)
                        .foregroundStyle(.yellow)
                        .cornerRadius(6)
                        .annotation(position: .overlay) {
                            if stat.noOf9 > 0 {
                                Text("9")
                            }
                        }
                    SectorMark(angle: .value("8", stat.noOf8), angularInset: 2)
                        .foregroundStyle(.red)
                        .cornerRadius(6)
                        .annotation(position: .overlay) {
                            if stat.noOf8 > 0 {
                                Text("8")
                            }
                        }
                    SectorMark(angle: .value("7", stat.noOf7), angularInset: 2)
                        .foregroundStyle(.red)
                        .cornerRadius(6)
                        .annotation(position: .overlay) {
                            if stat.noOf7 > 0 {
                                Text("7")
                            }
                        }
                    SectorMark(angle: .value("6", stat.noOf6), angularInset: 2)
                        .foregroundStyle(.cyan)
                        .cornerRadius(6)
                        .annotation(position: .overlay) {
                            if stat.noOf6 > 0 {
                                Text("6")
                            }
                        }
                    SectorMark(angle: .value("5", stat.noOf5), angularInset: 2)
                        .foregroundStyle(.cyan)
                        .cornerRadius(6)
                        .annotation(position: .overlay) {
                            if stat.noOf5 > 0 {
                                Text("5")
                            }
                        }
                    SectorMark(angle: .value("4", stat.noOf4), angularInset: 2)
                        .foregroundStyle(.black)
                        .cornerRadius(6)
                        .annotation(position: .overlay) {
                            if stat.noOf4 > 0 {
                                Text("4")
                            }
                        }
                    SectorMark(angle: .value("3", stat.noOf3), angularInset: 2)
                        .foregroundStyle(.black)
                        .cornerRadius(6)
                        .annotation(position: .overlay) {
                            if stat.noOf3 > 0 {
                                Text("3")
                            }
                        }
                    SectorMark(angle: .value("2", stat.noOf2), angularInset: 2)
                        .foregroundStyle(.gray.opacity(0.5))
                        .cornerRadius(6)
                        .annotation(position: .overlay) {
                            if stat.noOf2 > 0 {
                                Text("2")
                            }
                        }
                    SectorMark(angle: .value("1", stat.noOf1), angularInset: 2)
                        .foregroundStyle(.gray.opacity(0.5))
                        .cornerRadius(6)
                        .annotation(position: .overlay) {
                            if stat.noOf1 > 0 {
                                Text("1")
                            }
                        }
                    SectorMark(angle: .value("M", stat.noOfM), angularInset: 2)
                        .foregroundStyle(.gray.opacity(0.5))
                        .cornerRadius(6)
                        .annotation(position: .overlay) {
                            if stat.noOfM > 0 {
                                Text("M")
                            }
                        }
                }
                .scaledToFit()
                Text("**Performance Score:** \(twoDPFormat.string(for: stat.perfScore) ?? "")")
                Text("**Performance Improvement:** \(percentFormat.string(for: stat.perfImprovement) ?? "")")
            }
        }
        .navigationTitle(viewModel.score.date.formatted(date: .numeric, time: .shortened))
        .task {
            await viewModel.loadData()
        }
    }
    
    init (score: Score) {
        self.viewModel = StatsViewModel(score: score)
    }
}

#Preview {
    let score = Score(scoreId: "", archerId: "", date: Date.now, bowType: "Bareboew", targetSize: 80, distance: 18, scoreTotal: 100, instructorComment: "")
    StatsView(score: score)
}
