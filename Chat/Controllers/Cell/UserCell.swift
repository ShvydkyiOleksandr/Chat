//
//  UserCell.swift
//  Chat
//
//  Created by Олександр Швидкий on 30.04.2022.
//

import UIKit

class UserCell: UICollectionViewCell, SelfConfiguringCell {
    
    let userImageView = UIImageView()
    let userLabel: UILabel = UILabel(text: "text", font: .LaoSangamMN20())
    let containerView = UIView()
    
    static var reuseId: String = "UserCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupConstraints()
        
        self.layer.shadowColor = #colorLiteral(red: 0.787740171, green: 0.787740171, blue: 0.787740171, alpha: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 4
        self.containerView.clipsToBounds = true
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let user: MUser = value as? MUser else { return }
        userImageView.image = UIImage(named: user.avatarStringURL)
        userLabel.text = user.username
    }
    
    private func setupConstraints() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.backgroundColor = .red
        
        addSubview(containerView)
        containerView.addSubview(userImageView)
        containerView.addSubview(userLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            userImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            userLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            userLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SwiftUI
import SwiftUI

struct UserChatProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let viewController = MainTabBarController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
