//
//  SignUpView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 12/12/2024.
//

import SwiftUI
import PhotosUI

struct SignUpView: View {
    
    @Environment(\.modelContext) private var context
    @State private var profileItem: PhotosPickerItem?
    @State private var viewModel = SignUpViewModel()
    
    var body: some View {
        Form {
            Section {
                CentralisedStack(orientation: .horizontal) {
                    PhotosPicker(selection: $profileItem, matching: .images) {
                        photosPickerPlaceholder(data: viewModel.profileImage)
                    }
                }
                .alignmentGuide(.listRowSeparatorLeading) { _ in 0}
                TextField("Full Name", text: $viewModel.name)
                    .textInputAutocapitalization(.words)
            } footer: {
                VStack (alignment: .leading) {
                    errorMessage(error: viewModel.error)
                    CentralisedStack(orientation: .horizontal) {
                        submitButton
                    }
                }
            }
        }
        .navigationTitle("Sign Up")
        .onChange(of: profileItem) {
            Task {
                viewModel.profileImage = try? await profileItem?.loadTransferable(type: Data.self)
            }
        }
    }
    
    @ViewBuilder
    private var submitButton: some View {
        Button("Submit") { signUpAndInsert() }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .frame(alignment: .center)
            .padding(.vertical)
    }
    
    @ViewBuilder
    private var imagePlusIcon: some View {
        Image(systemName: "photo.badge.plus")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
    }
    
    @ViewBuilder
    private func errorMessage(error: ValidationError?) -> some View {
        if let error {
            Text(error.localizedDescription)
                .bold()
                .foregroundStyle(.red)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func photosPickerPlaceholder(data: Data?) -> some View {
        VStack {
            if let data, let image = data.createCGImage() {
                profileImage(image)
            } else {
                imagePlusIcon
            }
            
            Text("Profile Picture")
        }
    }
    
    @ViewBuilder
    private func profileImage(_ image: CGImage) -> some View {
        Image(decorative: image, scale: 1)
            .resizable()
            .scaledToFill()
            .frame(width: 75, height: 75)
            .clipShape(.circle)
    }
    
    // MARK: - SwiftData
    
    private func signUpAndInsert() {
        do {
            let archer = try viewModel.signUp()
            context.insert(archer)
            
        } catch { return }
    }
}

#Preview {
    SignUpView()
}
