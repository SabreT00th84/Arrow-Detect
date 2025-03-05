//
//  SignUpView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 12/12/2024.
//

import SwiftUI
import PhotosUI

struct SignUpView: View {
    
    @Binding var path: NavigationPath
    @State var profileItem: PhotosPickerItem?
    @StateObject var viewModel = SignUpViewModel()
    
    var body: some View {
        ZStack {
            Form {
                Section (footer: Text(viewModel.message)) {
                    PhotosPicker("Profile Picture", selection: $profileItem, matching: .images)
                    TextField("Full Name", text: $viewModel.name)
                        .textInputAutocapitalization(.words)
                    TextField("Email", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                    SecureField("Password", text: $viewModel.password)
                    SecureField("Confirm", text: $viewModel.confirm)
                    Picker("Role", selection: $viewModel.role) {
                        Text("Archer").tag(SignUpViewModel.Roles.archer)
                        Text("Instructor").tag(SignUpViewModel.Roles.instructor)
                    }
                }
            }
            .onChange(of: profileItem) {
                Task {
                    viewModel.profileImage = try? await profileItem?.loadTransferable(type: Data.self)
                }
            }
            VStack {
                    Button("Submit") {
                        viewModel.SignUp()
                    }
                    .buttonStyle(.borderedProminent)
                .controlSize(.large)
                Spacer()
            }
            .padding(.top, 300 + CGFloat(viewModel.offset))
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
            }
        }
        .scrollDisabled(true)
        .navigationTitle("Sign-Up")
    }
}

#Preview {
    SignUpView(path: .constant(NavigationPath()))
}
