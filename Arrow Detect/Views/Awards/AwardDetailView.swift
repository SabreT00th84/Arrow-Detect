//
//  AwardDetailView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 10/03/2025.
//

import SwiftUI
import SwiftData

struct AwardDetailView: View {
    
    @Environment(\.modelContext) private var context
    @Binding private var path: NavigationPath
    @State private var viewModel: AwardDetailViewModel
    @Query private var qualifyingScores: [Score]
    
    init (path: Binding<NavigationPath>, awardStatus: AwardStatus) {
        self.viewModel = AwardDetailViewModel(awardStatus: awardStatus)
        self._path = path
        
        var scoreFetchDescriptor: FetchDescriptor<Score> {
            let maxTarget = awardStatus.award.maximumTargetSize
            let minDistance = awardStatus.award.minimumDistance
            let combined = #Predicate<Score> {score in
                ((score.bowType == "Barebow" && score.scoreTotal >= 86)
                || (score.bowType == "Recurve" && score.scoreTotal >= 115))
                && score.targetSize <= maxTarget
                && score.distance >= minDistance
            }
            return FetchDescriptor<Score>(predicate: combined, sortBy: [SortDescriptor(\.scoreTotal, order: .reverse), SortDescriptor(\.date, order: .reverse)])
        }
        
        _qualifyingScores = Query(scoreFetchDescriptor)
    }
    
    var body: some View {
        List {
            Section {
                qualifyingScore(for: qualifyingScores.first)
            } header: {
                awardProgress(for: viewModel.awardStatus.completionRatio,
                                      noOfRequirements: viewModel.awardStatus.award.noOfRequirements
                )
            }
            
            ForEach(viewModel.awardStatus.skillStatuses.sorted(by: {$0.skill.skillNo < $1.skill.skillNo})) { skStatus in
                Section {
                    requirementsList(for: skStatus, isPerformance: skStatus.skill.skillNo == 0)
                } header: { skillProgress(for: skStatus) }
            }
        }
    }
    
    private var percentFormat: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    @ViewBuilder
    private func awardProgress(for completion: Float, noOfRequirements: Int) -> some View {
        VStack (alignment: .leading){
            progressBar(for: completion)
            Text("**Completion:** \(Int(completion * Float(noOfRequirements)))/\(noOfRequirements)")
            Text("Qualifying Score")
                .font(.headline)
        }
    }
    
    @ViewBuilder
    private func progressBar(for completion: Float) -> some View {
        HStack {
            ProgressView(value: completion)
                .progressViewStyle(.linear)
            Text(percentFormat.string(for: completion) ?? "")
        }
    }
    
    @ViewBuilder
    private func qualifyingScore(for score: Score?) -> some View {
        if let score {
            NavigationLink(value: AwardsDestinations.qualifyingScoreStat(score: score)) {
                Text(score.date.formatted(date: .abbreviated, time: .shortened))
            }
        } else {
            Text("No qualifying score")
        }
    }
    
    @ViewBuilder
    private func requirementsList(for skStatus: SkillStatus, isPerformance: Bool) -> some View {
        ForEach (skStatus.requirementStatuses) { reqStatus in
            HStack {
                Button {
                    viewModel.updateRequirementStatus(reqStatus: reqStatus, awardStatus: viewModel.awardStatus)
                } label: { checkmark(isCompleted: reqStatus.isCompleted) }
                .disabled(isPerformance)
                Text(reqStatus.requirement.desc)
            }
            .onAppear {
                if isPerformance, qualifyingScores.first != nil {
                    viewModel.updateRequirementStatus(to: true, reqStatus: reqStatus, awardStatus: viewModel.awardStatus)
                }
            }
        }
    }
    
    @ViewBuilder
    private func skillProgress(for skStatus: SkillStatus) -> some View {
        VStack(alignment: .leading) {
            HStack {
                checkmark(isCompleted: skStatus.isCompleted)
                Text(skStatus.skill.name)
                    .font(.headline)
            }
            progressBar(for: skStatus.completionRatio)
        }
    }
    
    @ViewBuilder
    private func checkmark(isCompleted: Bool) -> some View {
        Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
            .foregroundStyle(Color.accent)
    }
}
