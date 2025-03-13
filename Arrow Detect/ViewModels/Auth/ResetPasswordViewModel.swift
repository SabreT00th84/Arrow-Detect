//
//  ResetPasswordViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 26/12/2024.
//

import FirebaseAuth
import Foundation

@Observable
class ResetPasswordViewModel {
    var email: String = ""
    var errorMessage:String = ""
    
    func SendEmail () {
        guard NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}").evaluate(with: email) else {
            errorMessage = "Please enter a valid email."
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email)
    }
}
