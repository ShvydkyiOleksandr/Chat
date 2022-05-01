//
//  LoginViewController.swift
//  Chat
//
//  Created by Олександр Швидкий on 27.04.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    let welcomelabel = UILabel(text: "Welcome back!", font: .avenir26())
    
    let loginWithLabel = UILabel(text: "Login With")
    let orLabel = UILabel(text: "or")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let needAnAccountLabel = UILabel(text: "Need an account?")
    
    let googleButton = UIButton(title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true)
    
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    
    let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .buttonDark())
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.buttonRed(), for: .normal)
        button.titleLabel?.font = .avenir20()
        return button
    }()
    
    weak var delegate: AuthNavigationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleButton.customizeGooglebutton()

        view.backgroundColor = .white
        setupConstraints()
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        AuthenticationService.shared.login(email: emailTextField.text!,
                                           password: passwordTextField.text!) { result in
            switch result {
            case .success(let user):
                self.showAlert(with: "Successfully!", and: "You are authorized") {
                    FirestoreService.shared.getUserData(user: user) { result in
                        switch result {
                        case .success(let muser):
                            let mainTabBar = MainTabBarController(currentUser: muser)
                            mainTabBar.modalPresentationStyle = .fullScreen
                            self.present(mainTabBar, animated: true, completion: nil)
                        case .failure(_):
                            self.present(SetupProfileViewController(currentUser: user), animated: true, completion: nil)
                        }
                    }
                }
            case .failure(let error):
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
    }
    
    @objc private func signUpButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
        }
    }
}

// MARK: - Setup Constraint
extension LoginViewController {
    private func setupConstraints() {
        let loginWithView = ButtonFromView(label: loginWithLabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField],
                                         axis: .vertical,
                                         spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField],
                                         axis: .vertical,
                                         spacing: 0)
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let stackView = UIStackView(arrangedSubviews: [
            loginWithView,
            orLabel,
            emailStackView,
            passwordStackView,
            loginButton
        ],
                                    axis: .vertical,
                                    spacing: 40)
        signUpButton.contentHorizontalAlignment = .leading
        let bottomStackView = UIStackView(arrangedSubviews: [needAnAccountLabel, signUpButton],
                                          axis: .horizontal,
                                          spacing: 10)
        bottomStackView.alignment = .firstBaseline
        
        welcomelabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomelabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            welcomelabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            welcomelabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: welcomelabel.bottomAnchor, constant: 160),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct LoginVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = LoginViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
