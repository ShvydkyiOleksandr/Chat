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
        
        guard Validators.isFilled(email: email, password: password, confirmPassword: confirmPassword) else {
            completion(.failure(AuthenticationError.notFilled))
            return
        }
        
        guard password!.lowercased() == confirmPassword!.lowercased() else {
            completion(.failure(AuthenticationError.passwordsDoNotMatch))
            return
        }
        
        guard Validators.isSimpleEmail(email!) else {
            completion(.failure(AuthenticationError.invalidEmail))
            return
        }
        
        auth.createUser(withEmail: email!, password: password!) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            
            completion(.success(result.user))
        }
    }
    
    func login(email: String?, password: String?, completion:  @escaping(Result<User, Error>) -> Void) {
        
        guard let email = email, let password = password else {
            completion(.failure(AuthenticationError.notFilled))
            return
        }
        
        auth.signIn(withEmail: email, password: password) { result, error in
            guard let result = result else {
                completion(.failure(error!))
                return
            }
            completion(.success(result.user))
        }
    }
}
