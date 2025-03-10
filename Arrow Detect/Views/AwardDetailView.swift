//
//  AwardDetailView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 10/03/2025.
//

import SwiftUI

struct AwardDetailView: View {
    
    @State var viewModel: AwardDetailViewModel
    
    var body: some View {
        Text(String(describing: viewModel.awardTuple))
    }
    
    init (awardTuple: (Award, AwardStatus)) {
        self.viewModel = AwardDetailViewModel(awardTuple: awardTuple)
    }
}

/*#Preview {
    AwardDetailView()
}*/
