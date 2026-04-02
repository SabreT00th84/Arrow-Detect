//
//  ProfileEditViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 30/11/2025.
//

import Foundation

@Observable
final class ProfileEditViewModel {
    
    var archer: Archer
    var name: String
    var error: ValidationError?
    var profileImage: Data?
    
    init (archer: Archer) {
        
        self.archer = archer
        self.name = archer.name
        self.profileImage = archer.image
    }
    
    func submit() throws(ValidationError) -> Bool {
        do {
            try validate()
            
            if name != archer.name {
                archer.name = name
            }
            
            if profileImage != archer.image {
                archer.image = profileImage
            }
            
            return true
        } catch let error {
            
            self.error = error
            throw error
        }
    }
    
    private func validate() throws(ValidationError) {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw .emptyFields }
    }
}
