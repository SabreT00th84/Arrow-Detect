//
//  LoginView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 07/12/2024.
//

import SwiftUI

struct LoginView: View {
    
    @State var viewModel = LoginViewModel()
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack (path: $path) {
            ZStack {
                Form {
                    Section {
                        TextField("Email", text: $viewModel.email)
                        SecureField("Password", text: $viewModel.password)
                    }footer: {
                        VStack (alignment: .leading){
                            HStack {
                                Spacer()
                                NavigationLink("Forgot Password?", destination: ResetPasswordView(path: $path))
                            }
                            Text(viewModel.errorMessage)
                            HStack {
                                Spacer()
                                NavigationLink("Sign Up", destination: SignUpView(path: $path))
                                    .buttonStyle(.bordered)
                                Button("Submit") {
                                    viewModel.Login()
                                }
                                .buttonStyle(.borderedProminent)
                                .alert("Sign up?", isPresented: $viewModel.noAccount) {
                                    Button("No") {}
                                    Button("Yes", role: .cancel, action: {viewModel.showSignUp = true})
                                } message: {
                                    Text("You do not seem to have an account with arrow detect. would you like to sign up?")
                                }
                                Spacer()
                            }
                            .controlSize(.large)
                            .padding(.vertical)
                        }
                    }
                }
                .navigationTitle("Login")
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                }
            }
            .scrollDisabled(true)
            .navigationDestination(isPresented: $viewModel.showSignUp, destination: {SignUpView(path: $path)})
        }
        
    }
}
#Preview {
    LoginView()
}
