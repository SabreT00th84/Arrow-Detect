//
//  ClubLinkView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 20/01/2025.
//

import SwiftUI

struct ClubLinkView: View {
    
    @State private var viewModel = ClubLinkViewModel()
    
    var body: some View {
        Group {
            if let instructor = viewModel.insUser, let archer = viewModel.archer {
                VStack {
                    Text("Instructor Details:")
                        .font(.headline)
                    Text("**Name:** \(instructor.name)")
                    Text("**ID:** \(archer.instructorId)")
                        .textSelection(.enabled)
                    Button("Unlink") {
                        Task {
                            await viewModel.unlink()
                        }
                    }
                    .tint(Color.red)
                }
            }else {
                ZStack {
                    Form {
                        Section {
                            TextField("Instructor ID", text: $viewModel.instructorId)
                                .textInputAutocapitalization(.never)
                        }header: {
                            Text("Please enter your instructor's ID. You can find this by asking your instructor for their ID.")
                        }footer: {
                            VStack (alignment: .leading) { //Was added later due to button disappearing when error message appeared
                                if let error = viewModel.errorMessage {
                                    Text(error)
                                }
                                HStack {
                                    Spacer()
                                    Button("Submit") {
                                        Task {
                                            await viewModel.submit()
                                            viewModel.isLoading = false 
                                        }
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .controlSize(.large)
                                    .padding()
                                    .alert("Success", isPresented: $viewModel.success) {
                                        Button("OK") {}
                                    }message: {
                                        Text("You have now been added to the club")
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                    .navigationTitle("Club Link")
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                }
            }
        }
        .task {
            await viewModel.loadData()
        }
    }
}

#Preview {
    ClubLinkView()
}
