//
//  AuthenticationService.swift
//  Chat
//
//  Created by Олександр Швидкий on 01.05.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class AuthenticationService {
    
    static let shared = AuthenticationService()
    private var auth = Auth.auth()
    
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
    
    func googleLogin(viewController: UIViewController) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { user, error in
            if let error = error {
                viewController.showAlert(with: "Error", and: error.localizedDescription)
                return
            }
            guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    viewController.showAlert(with: "Error", and: error.localizedDescription)
                    return
                }
                guard let user = authResult?.user else { return }
                FirestoreService.shared.getUserData(user: user) { result in
                    switch result {
                    case .success(let muser):
                        viewController.showAlert(with: "Successfully", and: "You are authorized") {
                            let mainTabBar = MainTabBarController(currentUser: muser)
                            mainTabBar.modalPresentationStyle = .fullScreen
                            viewController.present(mainTabBar, animated: true, completion: nil)
                        }
                    case .failure(_):
                        viewController.showAlert(with: "Successfully", and: "You are register") {
                            viewController.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                        }
                    }
                }
            }
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
