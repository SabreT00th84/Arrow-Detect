//
//  ResetPasswordViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 26/12/2024.
//

import FirebaseAuth
import Foundation

class ResetPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var errorMessage:String = ""
    @Published var offset = 0
    
    func SendEmail () {
        guard NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}").evaluate(with: email) else {
            errorMessage = "Please enter a valid email."
            offset = 20
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email)
    }
}
