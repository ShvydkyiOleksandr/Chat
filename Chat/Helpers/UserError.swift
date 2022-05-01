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
    case cannotGetUserInfo
    case cannotUnwrapToUser
}

extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Fill in all the fields", comment: "")
        case .photoNotExist:
            return NSLocalizedString("User did not chose the photo", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("Unable to download user information from Firebase", comment: "")
        case .cannotUnwrapToUser:
            return NSLocalizedString("Unable to convert User to Muser", comment: "")
        }
    }
}
