//
//  ProfileViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 28/12/2024.
//

import FirebaseAuth
import FirebaseFirestore
import Cloudinary
import Foundation

@Observable
class ProfileViewModel {

    var user = User(userId: "", name: "", email: "", joinDate: Date.now, isInstructor: false, imageId: "")
    var instructor: Instructor?
    var imageUrl = ""
    
    func loadData () async {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Could not find current user")
            return
        }
        
        let db = Firestore.firestore()
        do {
            let snapshot = try await db.collection("Users").document(userID).getDocument()
            let instructor = try await db.collection("Instructors").document(userID).getDocument()
            
            if instructor.exists {
                try DispatchQueue.main.sync {
                    self.instructor = try instructor.data(as: Instructor.self)
                }
            }
            
            try DispatchQueue.main.sync {
                self.user = try snapshot.data(as: User.self)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func generateImageUrl() {
        let cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: "duy78o4dc", apiKey: "984745322689627", secure: true))
        guard let url = cloudinary.createUrl().setTransformation(CLDTransformation().setGravity("face").setHeight(50).setWidth(50).setCrop("thumb")).generate(user.imageId) else {
            print("error occured generating url")
            return
        }
        self.imageUrl = url
    }
}
