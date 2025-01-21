//
//  ScoresheetViewModel.swift
//  Arrow Detect
//
//  Created by Eesa Adam on 20/01/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ScoresheetViewModel: ObservableObject {
    @Published var archer = Archer(id: "", userId: "", instructorId: "")
    @Published var scores:[[String]] = Array(repeating: Array(repeating: "", count: 3), count: 5)
    @Published var errorMessage = ""
    
    func loadData() async {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Could not find current user")
            return
        }
        
        let db = Firestore.firestore()
        
        do {
            let snapshot = try await db.collection("Archers").document(userID).getDocument()
            try DispatchQueue.main.sync {
                self.archer = try snapshot.data(as: Archer.self)
            }
        } catch let error {
            print(error.localizedDescription)
            return
        }
    }
}
