//
//  SignUpViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 30/11/2025.
//

import Foundation

@Observable
final class SignUpViewModel {
    
    var name = ""
    var error: ValidationError?
    var profileImage: Data?
    
    func signUp() throws(ValidationError) -> Archer {
        do {
            try validate()
            let archer = Archer(name: name, joinDate: Date.now, image: profileImage)
            return archer
        } catch let error {
            self.error = error
            throw error
        }
    }
    
    private func validate() throws(ValidationError) {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw .emptyFields }
    }
}
