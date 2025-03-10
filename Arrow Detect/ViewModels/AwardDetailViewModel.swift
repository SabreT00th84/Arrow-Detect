//
//  AwardDetailViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 10/03/2025.
//

import Foundation

@Observable
class AwardDetailViewModel {
    let awardTuple: (Award, AwardStatus)
    
    init(awardTuple: (Award, AwardStatus)) {
        self.awardTuple = awardTuple
    }
}
