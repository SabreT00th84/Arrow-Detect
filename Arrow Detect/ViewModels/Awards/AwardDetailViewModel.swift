//
//  AwardDetailViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 30/11/2025.
//

import Foundation

@Observable
final class AwardDetailViewModel {
    
    var awardStatus: AwardStatus
    
    init(awardStatus: AwardStatus) {
        self.awardStatus = awardStatus
    }
    
    @MainActor
    func updateRequirementStatus(to newStatus: Bool? = nil, reqStatus: RequirementStatus, awardStatus: AwardStatus) {
        if let newStatus {
            reqStatus.isCompleted = newStatus
        } else {
            reqStatus.isCompleted.toggle()
        }
    }
}
