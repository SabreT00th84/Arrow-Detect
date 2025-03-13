//
//  ClubLinkViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 12/03/2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@Observable
class ClubLinkViewModel {
    var instructorId = ""
    var errorMessage: String?
    var isLoading = false
    var success = false
    
    private func validate () async -> Bool {
        do {
            guard !instructorId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                errorMessage = "Please fill in all fields"
                return false
            }
            let db = Firestore.firestore()
            let instructor = try await db.collection("Instructors").document(instructorId).getDocument()
            if instructor.exists { //if statement added because the instructorid was not being verified
                return true
            }else {
                errorMessage = "Instructor not found"
                return false
            }
        }catch let error {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func submit () async {
        do {
            isLoading = true
            guard await validate() else {
                isLoading = false
                return
            }
            guard let userId = Auth.auth().currentUser?.uid else {
                errorMessage = "User id not logged in"
                isLoading = false
                return
            }
            let db = Firestore.firestore()
            guard let archer = try await db.collection("Archers").whereField("userId", isEqualTo: userId).getDocuments().documents.first?.data(as: Archer.self) else {
                errorMessage = "Could not retrieve archer record"
                isLoading = false
                return
            }
            let updatedArcher = Archer(userId: userId, instructorId: instructorId)
            try db.collection("Archers").document(archer.archerId!).setData(from: updatedArcher, merge: true)
            isLoading = false
            success = true
        }catch let error {
            errorMessage = error.localizedDescription
            isLoading = false
            return
        }
    }
}
