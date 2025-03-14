//
//  ProfileView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 28/12/2024.
//

import SwiftUI

struct ProfileView: View {
    
    @AppStorage("Instructor") var isInstructor: Bool?
    @State var viewModel = ProfileViewModel()
    @State var path = NavigationPath()
    
    var body: some View {
        List {
            Section {
                NavigationLink (destination: {ProfileEditView(givenUser: viewModel.user)}) {
                    HStack {
                        AsyncImage(url: URL(string: viewModel.imageUrl)) { image in
                            image.resizable()
                        } placeholder : {
                            Image(systemName: "person.circle")
                                .resizable()
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(.circle)
                        VStack (alignment: .leading) {
                            Text(viewModel.user.name)
                            Text(viewModel.user.email)
                        }
                    }
                }
                .navigationTitle("Profile")
                if let instructorId = viewModel.instructor?.instructorId, isInstructor ?? false {
                    Text("**InstructorId:** \(instructorId)")
                        .textSelection(.enabled)
                }
                Text("**Joined:** \(viewModel.user.joinDate.formatted(date: .complete, time: .omitted))")
            }footer: {
                HStack {
                    Spacer()
                    NavigationLink("Reset Password") {ResetPasswordView()}
                    .tint(Color.orange)
                    Button("Log Out") {viewModel.logOut()}
                        .tint(Color.red)
                    Spacer()
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .padding(.vertical)
            }
        }
        .task {
            await viewModel.loadData()
            viewModel.generateImageUrl()
        }
    }
}

#Preview {
    ProfileView()
}
