//
//  SignUpViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 26/12/2024.
//
import Cloudinary
import FirebaseFirestore
import FirebaseAuth
import Foundation
import PhotosUI

class SignUpViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirm = ""
    @Published var role = Roles.archer
    @Published var message = ""
    @Published var offset = 0
    @Published var isLoading = false
    @Published var hasAccount = false
    @Published var profileImage: Data?
    
    enum Roles {
        case archer, instructor
    }
    
    func SignUp () {
        guard validate() else {
            offset = 20
            return
        }
        isLoading = true
        DispatchQueue.main.async {
            Task {
                await self.createUserRecord()
            }
            return
        }
    }
    
    
    private func ceateLoginRecord () async -> AuthDataResult? {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            return result
        } catch {
            DispatchQueue.main.sync {
                self.message = error.localizedDescription
                self.offset = 40
                self.isLoading = false
            }
            return nil
        }
    }
    
    private func createUserRecord () async {
        let publicId: String
        
        if self.profileImage != nil {
            do {
                publicId = try await uploadImage(image: UIImage(data: (self.profileImage!))!)
            } catch {
                DispatchQueue.main.sync {
                    self.message = error.localizedDescription
                    self.offset = 40
                    self.isLoading = false
                }
                return
            }
        } else {
             publicId = ""
        }
        guard let result = await ceateLoginRecord() else {
            DispatchQueue.main.sync {
                self.isLoading = false
            }
            return
        }
        
        let userId = result.user.uid
        
        let newUser = User(userId: userId, name: name, email: email, joinDate: Date.now, isInstructor: role == Roles.instructor, imageId: publicId)
        let db = Firestore.firestore()
        DispatchQueue.main.sync {
            do {
                try db.collection("Users").document(userId).setData(from: newUser)
                if role == Roles.instructor {
                    let document = db.collection("Instructors").document()
                    let instructor = Instructor(instructorId: document.documentID, userId: userId)
                    try document.setData(from: instructor)
                } else {
                    let document = db.collection("Archers").document()
                    let archer = Archer(archerId: document.documentID, userId: userId, instructorId: "")
                    try document.setData(from: archer)
                }
                self.isLoading = false
            } catch {
                self.message = error.localizedDescription
                self.offset = 40
                self.isLoading = false
            }
            return
        }
    }
    
    private func validate () -> Bool {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            message = "Please fill in all fields"
            return false
        }
        guard NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}").evaluate(with: email) else {
            message = "Please enter a valid email address"
            return false
        }
        guard password == confirm else {
            message = "Please make sure passwords match"
            return false
        }
        return true
    }
    
    private func uploadImage (image: UIImage) async throws -> String {
        guard let data = image.pngData() else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Could not convert image to data"))
        }
        do {
            let publicId = try await withCheckedThrowingContinuation { continuation in
                let cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: "duy78o4dc", apiKey: "984745322689627"))
                cloudinary.createUploader().upload(data: data, uploadPreset: "Profile-Picture", completionHandler:  { result, error in
                    if let result {
                        continuation.resume(returning: result.publicId)
                    } else if let error {
                        continuation.resume(throwing: error)
                    }
                })}
            return publicId ?? ""
        } catch let error {
            throw error
        }
    }
}
