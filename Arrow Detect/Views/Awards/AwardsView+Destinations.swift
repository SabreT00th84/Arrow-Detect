//
//  InfoView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 28/12/2024.
//

import SwiftUI
import SwiftData

enum AwardsDestinations: Hashable {
    
    case awardDetail(awardStatus: AwardStatus)
    case qualifyingScoreStat(score: Score)
    
    var title: String {
        switch self {
        case .awardDetail(awardStatus: let status):
            return status.award.name
        case .qualifyingScoreStat(score: let score):
            return score.date.formatted(date: .numeric, time: .shortened)
        }
    }
}

struct AwardsView: View {
    
    @Environment(\.modelContext) private var context
    @State private var path = NavigationPath()
    @State private var error: QueryError?
    @Query private var archers: [Archer]
    @Query private var awards: [Award]
    @Query(sort: \AwardStatus.award.awardNo) private var awardStatuses: [AwardStatus]
    
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(awardStatuses) {status in
                    NavigationLink (value: AwardsDestinations.awardDetail(awardStatus: status)) {
                        awardNameAndProgress(for: status)
                    }
                }
            }
            .navigationTitle("Awards")
            .navigationDestination(for: AwardsDestinations.self) { awardDestination in
                switch awardDestination {
                case .awardDetail(let status):
                    AwardDetailView(path: $path, awardStatus: status)
                        .navigationTitle(status.award.name)
                        .navigationBarTitleDisplayMode(.inline)
                case .qualifyingScoreStat(let score):
                    StatsView(path: $path, score: score)
                        .navigationTitle(score.date.formatted(date: .numeric, time: .shortened))
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .task {
                if awardStatuses.isEmpty {
                    if let archer = archers.first {
                        generateStatuses(archer: archer, awards: awards)
                    } else {
                        error = .retrievalErrorFor(object: "archer")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func awardNameAndProgress(for status: AwardStatus) -> some View {
        HStack {
            Text(status.award.name)
            ProgressView(value: status.completionRatio)
                .progressViewStyle(.linear)
            Text(twoDPFormat.string(for: status.completionRatio) ?? "")
        }
    }
    
    private var twoDPFormat: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter
    }
    
    // MARK: - SwiftData
    
    private func generateStatuses(archer: Archer, awards: [Award]) {
        for award in awards {
            let status = AwardStatus(archer: archer, award: award)
            context.insert(status)
            for skill in award.skills {
                let skillStatus = SkillStatus(awardStatus: status, skill: skill)
                context.insert(skillStatus)
                for requirement in skill.requirements {
                    let reqStatus = RequirementStatus(skillStatus: skillStatus, requirement: requirement, isCompleted: false)
                    context.insert(reqStatus)
                }
            }
        }
    }
}
