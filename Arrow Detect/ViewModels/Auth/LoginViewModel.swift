//
//  LoginViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 26/12/2024.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var noAccount = false
    @Published var showSignUp = false
    @Published var isLoading = false
    @Published var offset = 0
    
    func Login () {
        guard Validate() else {
            return
        }
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            self?.isLoading = false
            guard let self else {
                return
            }
            if let error, error.localizedDescription.contains("auth credential is malformed or has expired") {
                errorMessage = "Please check you have an account with us and that your email adress and password is correct"
                offset = 40
            }
        }
    }
    
    private func Validate () -> Bool {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please fill in all fields."
            offset = 20
            return false
        }
        guard NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}").evaluate(with: email) else {
            errorMessage = "Please enter a valid email."
            offset = 20
            return false
        }
        return true
    }
}
