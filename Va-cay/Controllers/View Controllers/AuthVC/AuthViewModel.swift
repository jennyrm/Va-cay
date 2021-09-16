//
//  AuthViewModel.swift
//  Va-cay
//
//  Created by James Lea on 7/29/21.
//

import Foundation
import FirebaseAuth

class AuthViewModel {
    
    static func login(email: String, password: String, completion: @escaping (String) -> Void) {
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                
                completion("\(error.localizedDescription)")
            }

            if result != nil {
                guard let result = result else {return}
                DispatchQueue.main.async {
                    UserController.sharedInstance.fetchUser(userId: result.user.uid) { result in
                        switch result {
                        case .success(let user):
                            UserController.sharedInstance.user = user
                            
                            completion("User logged in")
                        case .failure(let error):
                            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                            
                            completion("\(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    static func register(email: String, password: String, confirmPassword: String, completion: @escaping (String) -> Void){
        if password == confirmPassword {
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    
                    completion("\(error.localizedDescription)")
                }
                if result != nil {
                    print("Succesfully created account")
                    let newUser = User(email: email, userId: result!.user.uid)
                    UserController.sharedInstance.createUser(user: newUser)
                    
                    completion("Succesfully created account")
                }
            }
        }
    }

}//End of class
