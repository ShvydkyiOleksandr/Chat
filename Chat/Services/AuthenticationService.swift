//
//  AuthenticationService.swift
//  Chat
//
//  Created by Олександр Швидкий on 01.05.2022.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthenticationService {
    
    static let shared = AuthenticationService()
    private let auth = Auth.auth()
    
    func register(email: String?, password: String?, confirmPassword: String?, completion:  @escaping(Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email!, password: password!) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(result.user))
        }
    }
    
    func login(email: String?, password: String?, completion:  @escaping(Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email!, password: password!) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(result.user))
        }
    }
}
