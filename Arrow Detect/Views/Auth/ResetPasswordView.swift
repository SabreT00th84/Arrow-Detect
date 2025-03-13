//
//  ResetPasswordView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 12/12/2024.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @Binding var path: NavigationPath
    @State var viewModel = ResetPasswordViewModel()
    
    var body: some View {
        ZStack {
            Form {
                Section {
                    TextField("Email", text: $viewModel.email)
                }footer: {
                    VStack {
                        Text(viewModel.errorMessage)
                        HStack {
                            Spacer()
                            Button("Send Email") {
                                viewModel.SendEmail()
                                path.removeLast()
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Reset Password")
        }
    }
}
    
#Preview {
    ResetPasswordView(path: .constant(NavigationPath()))
}
