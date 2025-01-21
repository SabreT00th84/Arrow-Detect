//
//  ProfileEditViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 01/01/2025.
//

import Foundation
import SwiftUI
import PhotosUI
import FirebaseAuth
import FirebaseFirestore
import Cloudinary

class ProfileEditViewModel: ObservableObject {
    @Published var user: User
    @Published var email = ""
    @Published var name = ""
    @Published var errorMessage: String = ""
    @Published var offset = 0
    @Published var isLoading = false
    @Published var profileItem: PhotosPickerItem?
    @Published var profileImage: Data?
    private let cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: "duy78o4dc", apiKey: "984745322689627", secure: true))
    
    init (givenUser: User) {
        self.user = givenUser
    }
    
    func loadData () {
        email = user.email
        name = user.name
    }
    
    private func Validate () -> Bool {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
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
    
    func submit () {
        guard Validate()  else { return }
        isLoading = true
        Task {
            guard let userID = Auth.auth().currentUser?.uid else { return}
            let db = Firestore.firestore()
            let reference = db.collection("Users").document(userID)
            if email != user.email {
                try await Auth.auth().currentUser?.sendEmailVerification(beforeUpdatingEmail: email)
            }
            if name != user.name {
                try await reference.updateData(["name": name])
            }
            
            if profileImage != nil {
                do {
                    let publicId = try await uploadImage(image: UIImage(data: profileImage!)!)
                    try await reference.updateData(["publicId": publicId])
                } catch let error {
                    print("error uploading new public Id to database")
                    print(error)
                    return
                }
            }
        }
    }
    
    private func uploadImage (image: UIImage) async throws -> String {
        guard let data = image.pngData() else { return ""}
        if user.publicId != "" {
            do {
                let (signature, timestamp) = try await generateSignature(publicId: user.publicId, folder: "profile-pictures")
                try await deleteImage(publicId: user.publicId,  folder: "profile-pictures", signature: signature, timestamp: timestamp)
            } catch let error {
                print("error occured deleting old profile picture")
                throw error
            }
        }
        do {
            return try await withCheckedThrowingContinuation { continuation in
                cloudinary.createUploader().upload(data: data, uploadPreset: "Profile-Picture", completionHandler:  { result, error in
                    if let result, let publicId = result.publicId {
                        continuation.resume(returning: publicId)
                    } else if let error {
                        continuation.resume(throwing: error)
                    }
                    self.isLoading = false
                })}
        } catch let error {
            print("Error upploading new image")
            throw error
        }
    }
    
    private func generateSignature(publicId: String, folder: String) async throws -> (String, Int) {
        guard let appUrl = URL(string: "https://railway-cloudinary-production.up.railway.app/generate-destroy-signature/?publicId=\(publicId)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: appUrl)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        do {
            let jsonData = try JSONDecoder().decode(RailwayResponse.self, from: data)
            return (jsonData.signature, jsonData.timestamp)
        } catch {
            throw URLError(.cannotParseResponse)
        }
    }
    
    private func deleteImage(publicId: String, folder: String, signature: String, timestamp: Int) async throws {
        throw try await withCheckedThrowingContinuation { continuation in
            let params = CLDDestroyRequestParams().setSignature(CLDSignature(signature: signature, timestamp: NSNumber(value: timestamp)))
            cloudinary.createManagementApi().destroy(publicId, params: params, completionHandler: { result, error in
                if let error {
                    continuation.resume(throwing: error)
                }
            })
        }
    }
}
