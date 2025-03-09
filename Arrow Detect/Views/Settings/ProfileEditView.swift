//
//  ProfileEditView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 28/12/2024.
//

import PhotosUI
import Cloudinary
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

struct ProfileEditView: View {

    @StateObject var viewModel: ProfileEditViewModel
    
    var body: some View {
        ZStack {
            Form {
                Section(footer: Text(viewModel.errorMessage)) {
                    PhotosPicker("Profile Picture", selection: $viewModel.profileItem, matching: .images)
                    TextField("Full Name", text: $viewModel.name)
                    TextField("Email", text: $viewModel.email)
                }
            }
            .scrollDisabled(true)
            .navigationTitle("Edit Profile")
            .onChange(of: viewModel.profileItem) {
                Task{
                    viewModel.profileImage = try? await viewModel.profileItem?.loadTransferable(type: Data.self)
                }
            }
            .onAppear {viewModel.loadData()}
            Button("Submit") {
                viewModel.submit()
            }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.bottom, 100 - CGFloat(viewModel.offset))
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
            }
        }
    }
    
    
    init (givenUser: User) {
        self._viewModel = StateObject(wrappedValue: ProfileEditViewModel(givenUser: givenUser))
    }
}

#Preview {
    ProfileEditView(givenUser: User(userId: "1", name: "Your Name", email: "yourname@example.com", joinDate: Date.now, isInstructor: false, imageId: ""))
}
