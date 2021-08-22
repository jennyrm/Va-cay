//
//  UserController.swift
//  Va-cay
//
//  Created by James Lea on 7/28/21.
//

import Foundation
import FirebaseFirestore

class UserController {
    
    //MARK: - Shared Instance
    static let shared = UserController()
    
    //MARK: - Properties
    var user: User?
    
    //MARK: - Reference to DB
    let db = Firestore.firestore()
    
    //MARK: - Functions
    func createUser(user: User){
        db.collection("users").document(user.userId).setData([
            "email" : user.email,
            "userId" : user.userId
        ])
        self.user = user
    }
    
    // JAMLEA: Used to fetch user and store it on above user property
    func fetchUser(userId: String, completion: @escaping (Result<User, UserError>) -> Void) {
                    let queriedUser = db.collection("users").whereField("userId", isEqualTo: userId)
        
        queriedUser.getDocuments { snap, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            
            guard let snap = snap else {return}
            
            if snap.count == 1 {
                let userData = snap.documents[0].data()
                
                let email = userData["email"] as? String ?? ""
                let userId = userData["userId"] as? String ?? ""
            
            let userToReturn = User(email: email, userId: userId)
                completion(.success(userToReturn))
            } else {
                completion(.failure(.noData))
                return
            }
        }
    }
    
}//End of class
