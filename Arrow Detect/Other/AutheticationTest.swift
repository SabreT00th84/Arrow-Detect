//
//  AutheticationTest.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 26/12/2024.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class AuthenticationTest: ObservableObject {
    @Published var currentUserId = ""
    //@Published var documentExists = false
    private var handler: AuthStateDidChangeListenerHandle?
    //private var listener: ListenerRegistration?
    
    init () {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
            }
        }
    }
    
    public var isSignedIn: Bool {
        guard let user = Auth.auth().currentUser else { return false }
        user.reload { _ in }
        return Auth.auth().currentUser != nil
    }
    
    /*func checkDocument () {
        guard isSignedIn == true else { return}
        let reference = Firestore.firestore().collection("Users").document(currentUserId)
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard let snapshot, let self else { return}
            DispatchQueue.main.async {
                self.documentExists = snapshot.exists
            }
        }
    }*/
}
