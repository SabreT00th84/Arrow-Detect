//
//  LoginView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 07/12/2024.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewModel()
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack (path: $path) {
            ZStack {
                Form {
                    Section(footer: Text(viewModel.errorMessage)) {
                        TextField("Email", text: $viewModel.email)
                        SecureField("Password", text: $viewModel.password)
                    }
                }
                .navigationTitle("Login")
                VStack {
                    HStack {
                        Spacer()
                        NavigationLink("Forgot Password?", destination: ResetPasswordView(path: $path))
                            .padding()
                    }
                    HStack {
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
                    }
                    .controlSize(.large)
                    Spacer()
                }
                .padding(.top, 80 + CGFloat(viewModel.offset))
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
