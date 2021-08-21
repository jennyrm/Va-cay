//
//  User.swift
//  Va-cay
//
//  Created by James Lea on 7/28/21.
//

import Foundation

class User: Codable {
    
    //MARK: - Properties
    let email: String
    let userId: String
    
    //MARK: - Initializer
    init(email: String, userId: String) {
        self.email = email
        self.userId = userId
    }
    
}//End of class
