//
//  ProfileEditView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 28/12/2024.
//

import PhotosUI
import SwiftData
import SwiftUI

struct ProfileEditView: View {
    
    @Binding private var path: NavigationPath
    @State private var profileItem: PhotosPickerItem?
    @State private var viewModel: ProfileEditViewModel
    
    init(path: Binding<NavigationPath>, archer: Archer) {
        self._path = path
        self.viewModel = ProfileEditViewModel(archer: archer)
    }
    
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
            } footer: {
                VStack (alignment: .leading) {
                    errorMessage(error: viewModel.error)
                    CentralisedStack(orientation: .horizontal) {
                        submitButton
                    }
                }
            }
        }
        .onChange(of: profileItem) {
            Task {
                viewModel.profileImage = try? await profileItem?.loadTransferable(type: Data.self)
            }
        }
    }
    
    @ViewBuilder
    private var submitButton: some View {
        Button("Submit") {
            if (try? viewModel.submit()) != nil {
                path.removeLast()
            }
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .padding()
    }
    
    @ViewBuilder
    private var imagePlusIcon: some View {
        Image(systemName: "photo.badge.plus")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
    }
    
    @ViewBuilder
    private func profileImage(_ image: CGImage) -> some View {
        Image(decorative: image, scale: 1)
            .resizable()
            .scaledToFill()
            .frame(width: 75, height: 75)
            .clipShape(.circle)
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
    private func errorMessage(error: ValidationError?) -> some View {
        if let error {
            Text(error.localizedDescription)
                .bold()
                .foregroundStyle(.red)
        } else {
            EmptyView()
        }
    }
}
