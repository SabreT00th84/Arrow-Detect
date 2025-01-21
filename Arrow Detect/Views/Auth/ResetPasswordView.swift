//
//  ResetPasswordView.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 12/12/2024.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @Binding var path: NavigationPath
    @StateObject var viewModel = ResetPasswordViewModel()
    
    var body: some View {
        ZStack {
            Form {
                Section (footer: Text(viewModel.errorMessage)) {
                    TextField("Email", text: $viewModel.email)
                }
            }
            .navigationTitle("Reset Password")
            VStack{
                Button("Send Email") {
                    viewModel.SendEmail()
                    path.removeLast()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.top, 80 + CGFloat(viewModel.offset))
                Spacer()
            }
        }
    }
}
    
#Preview {
    ResetPasswordView(path: .constant(NavigationPath()))
}
