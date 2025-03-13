//
//  FeaturesView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 20/01/2025.
//

import SwiftUI

struct FeaturesView: View {
    
    @State private var viewModel = FeaturesViewModel()
    
    var body: some View {
        Form {
            Toggle(isOn: $viewModel.leaderboards, label: {Label("Leaderboards", systemImage: "trophy")})
            //Toggle(isOn: $viewModel.caching, label: {Label("Local Caching", systemImage: "gauge.with.dots.needle.67percent")})
        }
        .navigationTitle("Features")
        .onChange(of: viewModel.leaderboards) {
            viewModel.defaults.set(viewModel.leaderboards, forKey: "Leaderboards")
        }
        /*.onChange(of: viewModel.caching) {
            viewModel.defaults.set(viewModel.caching, forKey: "Caching")
        }*/
    }
}

#Preview {
    FeaturesView()
}
