//
//  AuthenticationError.swift
//  Chat
//
//  Created by Олександр Швидкий on 01.05.2022.
//

import Foundation

enum AuthenticationError {
    case notFilled
    case invalidEmail
    case passwordsDoNotMatch
    case unknownError
    case serverError
}

extension AuthenticationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Mail format is not valid", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Fill in all the fields", comment: "")
        case .passwordsDoNotMatch:
            return NSLocalizedString("Passwords do not match", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown error", comment: "")
        case .serverError:
            return NSLocalizedString("Server error", comment: "")
        }
    }
}
