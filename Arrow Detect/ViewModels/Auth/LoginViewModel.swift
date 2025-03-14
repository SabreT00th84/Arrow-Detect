//
//  LoginViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 26/12/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@Observable
class LoginViewModel {
    var email = ""
    var password = ""
    var errorMessage = ""
    var noAccount = false
    var showSignUp = false
    var isLoading = false
    var isInstructor = false
    
    func Login () async {
        do {
            guard Validate() else {
                isLoading = false
                return
            }
            isLoading = true
            try await Auth.auth().signIn(withEmail: email, password: password)
            guard let userId = Auth.auth().currentUser?.uid else {
                errorMessage = "Failed to log in"
                isLoading = false
                return
            }
            let user = try await Firestore.firestore().collection("Users").document(userId).getDocument(as: User.self)
            isInstructor = user.isInstructor
            isLoading = false
        }catch let error {
            isLoading = false
            print(error)
            if error.localizedDescription.contains("auth credential is malformed or has expired") {
                errorMessage = "Please check you have an account with us and that your email address and password is correct"
            }else {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    private func Validate () -> Bool {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }
        guard NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}").evaluate(with: email) else {
            errorMessage = "Please enter a valid email."
            return false
        }
        return true
    }
}
