//
//  AwardDetailView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 10/03/2025.
//

import SwiftUI

struct AwardDetailView: View {
    
    @State var viewModel: AwardDetailViewModel
    var twoDPFormat = NumberFormatter()
    var percentFormat = NumberFormatter()
    
    var body: some View {
        Group {
            HStack {
                ProgressView(value: viewModel.awardTuple.1.completionRatio)
                    .progressViewStyle(.linear)
                Text(percentFormat.string(for: viewModel.awardTuple.1.completionRatio * 100) ?? "")
            }
            .padding()
            Text("**Completion:** \(twoDPFormat.string(for: viewModel.awardTuple.1.completionRatio * Float (viewModel.awardTuple.0.noOfRequirements)) ?? "")/\(twoDPFormat.string(for:viewModel.awardTuple.0.noOfRequirements) ?? "")")
            Text("**Verified:** \(viewModel.verification)")
            
            List(viewModel.requirementsTuple, id: \.0.requirementId) {(requirement, status) in
                HStack {
                    Button {
                        viewModel.toggleStatus(tuple: (requirement, status))
                    }label: {
                        Image(systemName: status.isCompleted ? "checkmark.circle.fill" : "circle")
                    }
                    Text(requirement.description)
                }
            }
        }
    }
    
    init (awardTuple: (Award, AwardStatus), archer: Archer?) {
        self.viewModel = AwardDetailViewModel(awardTuple: awardTuple, archer: archer)
        twoDPFormat.numberStyle = .decimal
        twoDPFormat.maximumFractionDigits = 2
        percentFormat.numberStyle = .percent
        percentFormat.maximumFractionDigits = 2
    }
}

/*#Preview {
    AwardDetailView()
}*/
