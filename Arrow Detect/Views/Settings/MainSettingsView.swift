//
//  SettingsView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 28/12/2024.
//

import SwiftUI

struct MainSettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink (destination: ProfileView(), label: {Label("Profile", systemImage: "person.crop.circle")})
                NavigationLink (destination: ClubLinkView(), label: {Label("Club Link", systemImage: "person.3")})
                NavigationLink (destination: FeaturesView(), label: {Label("Features", systemImage: "wand.and.rays")})
            }
        }
    }
}

#Preview {
    MainSettingsView()
}
