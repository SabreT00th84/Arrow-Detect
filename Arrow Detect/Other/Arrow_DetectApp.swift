//
//  Arrow_DetectApp.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 13/10/2024.
//

import SwiftUI
import SwiftData

@main
struct ArrowDetectApp: App {
    
    let container: ModelContainer
    
    init() {
        container = try! ModelContainer(for:
            Archer.self,
            Arrow.self,
            Award.self,
            AwardStatus.self,
            End.self,
            Skill.self,
            Requirement.self,
            RequirementStatus.self,
            Score.self,
            Stat.self
        )
        seedDataIfNecessary(container: container)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(container)
    }
    
    private func seedDataIfNecessary(container: ModelContainer) {
        let context = container.mainContext
        
        let awardFetchDescriptor = FetchDescriptor<Award>()
        if (try? context.fetch(awardFetchDescriptor))?.isEmpty ?? true {
            for award in Award.allAwards {
                context.insert(award)
            }
            for skillArray in Award.allSkills {
                for skill in skillArray {
                    context.insert(skill)
                }
            }
            for requirementArray in Award.allRequirements {
                for requirement in requirementArray {
                    context.insert(requirement)
                }
            }
        }
    }
}
