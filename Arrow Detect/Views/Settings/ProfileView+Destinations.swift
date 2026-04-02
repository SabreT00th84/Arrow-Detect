//
//  ProfileView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 28/12/2024.
//

import SwiftUI
import SwiftData

enum ProfileDestinations: Hashable {
    
    case profileEdit(arhcer: Archer)
    
    var title: String {
        switch self {
        case .profileEdit: return "Edit Profile"
        }
    }
}

struct ProfileView: View {
    
    @Environment(\.modelContext) private var context
    @State private var path = NavigationPath()
    @State private var showDeletionAlert = false
    @State private var name = ""
    @Query private var archers: [Archer]
    
    var body: some View {
        NavigationStack (path: $path) {
            List {
                if let archer = archers.first {
                    archerInfoAndDeleteButton(archer: archer)
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
            .navigationTitle("Profile")
            .navigationDestination(for: ProfileDestinations.self)  { profileDestination in
                Group {
                    switch profileDestination {
                    case .profileEdit(arhcer: let archer):
                        ProfileEditView(path: $path, archer: archer)
                    }
                }
                .navigationTitle(profileDestination.title)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    @ViewBuilder
    private var placeholderImage: some View {
        Image(systemName: "person.circle")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
            .clipShape(.circle)
    }
    
    @ViewBuilder
    private func profileImage(_ image: CGImage) -> some View {
        Image(decorative: image, scale: 1)
            .resizable()
            .scaledToFill()
            .frame(width: 50, height: 50)
            .clipShape(.circle)
    }
    
    @ViewBuilder
    private func profileAndName(archer: Archer) -> some View {
        HStack {
            if let data = archer.image, let image = data.createCGImage() {
                profileImage(image)
            } else {
                placeholderImage
            }
            Text(archer.name)
        }
    }
    
    @ViewBuilder
    private func archerInfoAndDeleteButton(archer: Archer) -> some View {
        Section {
            NavigationLink (value: ProfileDestinations.profileEdit(arhcer: archer)) {
                profileAndName(archer: archer)
            }
            Text("**Joined:** \(archer.joinDate.formatted(date: .complete, time: .omitted))")
        } footer: {
            CentralisedStack(orientation: .horizontal) {
                deleteButtonAndAlert(archer: archer)
            }
        }
    }
    
    @ViewBuilder
    private func deleteButtonAndAlert(archer: Archer) -> some View {
        Button("Delete all user data") {showDeletionAlert = true}
            .padding()
            .tint(Color.red)
            .alert("Delete account?", isPresented: $showDeletionAlert) {
                TextField(archer.name, text: $name)
                Button("Yes", role: .destructive) {
                    context.delete(archer)
                }
            } message: {
                Text("Are you sure you want to delete your account? This is irreversible and will delete all data associated with the account permanently.\n\nPlease type the name on your profile below to continue.")
            }
    }
}
