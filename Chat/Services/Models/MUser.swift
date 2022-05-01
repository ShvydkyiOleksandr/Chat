//
//  MUser.swift
//  Chat
//
//  Created by Олександр Швидкий on 30.04.2022.
//

import Foundation

struct MUser: Hashable, Decodable {
    var username: String
    var avatarStringURL: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MUser, rhs: MUser) -> Bool {
        return lhs.id == rhs.id
    }
    
    func containts(filter: String?) -> Bool {
        guard let filter = filter else { return true }
        if filter.isEmpty { return true}
        let lowercaserFilter = filter.lowercased()
        return username.lowercased().contains(lowercaserFilter)
    }
}
