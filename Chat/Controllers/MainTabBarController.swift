//
//  MainTabBarController.swift
//  Chat
//
//  Created by Олександр Швидкий on 29.04.2022.
//

import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listVC = ListViewController()
        let peopleVC = PeopleViewController()
        
        tabBar.tintColor = #colorLiteral(red: 0.629904747, green: 0.4648939967, blue: 0.9760698676, alpha: 1)
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        let peopleImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig)!
        let convImage = UIImage(systemName: "person.2", withConfiguration: boldConfig)!
        
        viewControllers = [
            generateNavigationController(rootViewController: listVC, title: "Conversations", image: convImage),
            generateNavigationController(rootViewController: peopleVC, title: "People", image: peopleImage)
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}

// MARK: - SwiftUI
import SwiftUI

struct MainTabBarControllerProvider: PreviewProvider {
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