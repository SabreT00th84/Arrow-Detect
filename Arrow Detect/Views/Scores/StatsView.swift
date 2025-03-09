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
    
    var body: some View {
        let headers = ["End", "Arrow 1", "Arrow 2", "Arrow 3", "End Total"]
        Text("**Bow type:** \(viewModel.score.bowType)")
        Text("**Distance:** \(viewModel.score.distance)")
        Text("**Targt Size:** \(viewModel.score.targetSize)")
        ScrollView(.vertical) {
            LazyHGrid(rows: [GridItem(.fixed(50))], spacing: 10) {
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
            Text("Arrow Distibution")
                .font(.title)
            Chart {
                
            }
        }
        .navigationTitle(viewModel.score.date.formatted(date: .numeric, time: .shortened))
        .task {
            await viewModel.loadData()
        }
        
        /*List {
            /*HStack () {
                Spacer()
                Text("Arrow 1")
                Spacer()
                Text("Arrow 2")
                Spacer()
                Text("Arrow 3")
                Spacer()
                Text("End Total")
                Spacer()
            }
            .fontWeight(.bold)*/
            ForEach(viewModel.tableData.indices, id: \.self) {row in
                HStack (spacing: 50) {
                    Text("End \(row + 1)")
                        .fontWeight(.bold)
                    Spacer()
                    ForEach(viewModel.tableData[row].indices, id: \.self) {column in
                        Text(viewModel.tableData[row][column])
                    }
                    Spacer()
                    Text("\(viewModel.ends[row].endTotal)")
                        .fontWeight(.medium)
                }
            }
        }*/
    }
    
    init (score: Score) {
        self.viewModel = StatsViewModel(score: score)
    }
}

#Preview {
    let score = Score(scoreId: "", archerId: "", date: Date.now, bowType: "Bareboew", targetSize: 80, distance: 18, scoreTotal: 100, instructorComment: "")
    StatsView(score: score)
}
