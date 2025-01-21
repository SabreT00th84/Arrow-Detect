//
//  ProfileView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 28/12/2024.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    @State var path = NavigationPath()
    
    var body: some View {
        ZStack {
            List {
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
                //Text("\(Date(timeIntervalSince1970: viewModel.user?.joinDate ?? 0).formatted(date: .numeric, time: .omitted))")
            }
            HStack {
                Button("Reset Password") {
                    viewModel.logOut()
                }
                .tint(Color.orange)
                Button("Log Out") {viewModel.logOut()}
                    .tint(Color.red)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .padding(.bottom, 250)
        }
        .task() {
            await viewModel.loadData()
            viewModel.generateImageUrl()
        }
    }
}

#Preview {
    ProfileView()
}
