//
//  AuthNavigationDelegate.swift
//  Chat
//
//  Created by Олександр Швидкий on 01.05.2022.
//

import Foundation

protocol AuthNavigationDelegate: AnyObject {
    func toLoginVC()
    func toSignUpVC()
}
