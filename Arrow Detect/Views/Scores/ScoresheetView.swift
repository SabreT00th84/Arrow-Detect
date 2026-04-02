//
//  ScoreSheetView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 20/01/2025.
//

import SwiftUI
import SwiftData

struct ScoresheetView: View {
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Binding var path: NavigationPath
    @Query private var archers: [Archer]
    @Query(sort: \Stat.score.date, order: .reverse) private var stats: [Stat]
    @State private var viewModel = ScoresheetViewModel()
    @FocusState private var focusedArrow: ArrowFieldID?
    
    var body: some View {
        Form {
            pickers
            scoreFields
        }
        .fullScreenCover(item: $viewModel.selectedScanView) { index in
            ScanView(end: $viewModel.ends[index.int])
        }
    }
    
    @ViewBuilder
    private var pickers: some View {
        Picker("Target Size", selection: $viewModel.selectedSize) {
            ForEach(TargetSize.allCases) { size in
                Text("\(size.rawValue)cm")
            }
        }
        
        Picker("Bow Type", selection: $viewModel.selectedBow) {
            ForEach(BowType.allCases) { type in
                Text(type.rawValue)
            }
        }
        
        Picker("Distance", selection: $viewModel.selectedDistance) {
            ForEach(Distance.allCases) { distance in
                Text("\(distance.rawValue)m")
            }
        }
    }
    
    @ViewBuilder
    private var scoreFields: some View {
        ForEach (0..<5) { endIndex in
            Section {
                endView(endIndex: endIndex)
                scanViewButton(index: endIndex)
            } header: {
                Text("End \(endIndex + 1)")
            } footer: {
                submitButtonAndError(endIndex: endIndex)
            }
        }
    }
    
    @ViewBuilder
    private func submitButtonAndError(endIndex: Int) -> some View {
        VStack(alignment: .leading) {
            if endIndex == 4 {
                errorMessage(error: viewModel.error)
                HStack {
                    Spacer()
                    Button("Submit") { submitAndInsert(archer: archers.first) }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    private func errorMessage(error: Error?) -> some View {
        if let error {
            Text(error.localizedDescription)
                .bold()
                .foregroundStyle(.red)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func endView(endIndex: Int) -> some View {
        HStack {
            ForEach (0..<3) { arrowIndex in
                TextField("Arrow \(arrowIndex + 1)", text: $viewModel.ends[endIndex].arrows[arrowIndex].score)
                    .keyboardType(.numbersAndPunctuation)
                    .focused($focusedArrow, equals: ArrowFieldID(end: endIndex, arrow: arrowIndex))
                    .submitLabel((endIndex == 4 && arrowIndex == 2) ? .done : .next)
                    .onSubmit {
                        if arrowIndex < 2 {
                            focusedArrow = ArrowFieldID(end: endIndex, arrow: arrowIndex + 1)
                        } else if endIndex < 4 {
                            focusedArrow = ArrowFieldID(end: endIndex + 1, arrow: 0)
                        } else {
                            focusedArrow = nil
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    private func scanViewButton (index: Int) -> some View {
        let imageExists = viewModel.ends[index].image != nil
        
        Button {
            viewModel.selectedScanView = IdentifiableInt(int: index)
        } label: {
            Label(imageExists ? "View Image" : "Scan", systemImage: imageExists ? "photo" : "camera.viewfinder")
        }
    }
    
    // MARK: - SwiftData
    
    private func submitAndInsert(archer: Archer?) {
        do {
            let result = try viewModel.submit(archer: archers.first, prevStat: stats.first)
            if let archer {
                archer.scores.append(result)
                path.removeLast()
            }
        } catch {}
    }
}
