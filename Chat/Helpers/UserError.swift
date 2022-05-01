//
//  UserError.swift
//  Chat
//
//  Created by Олександр Швидкий on 02.05.2022.
//

import Foundation

enum UserError {
    case notFilled
    case photoNotExist
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Fill in all the fields", comment: "")
        case .photoNotExist:
            return NSLocalizedString("User did not chose the photo", comment: "")
        }
    }
}
