//
//  MUser.swift
//  Chat
//
//  Created by Олександр Швидкий on 30.04.2022.
//

import Foundation

struct MUser: Hashable, Decodable {
    var username: String
    var email: String
    var description: String
    var sex: String
    var avatarStringURL: String
    var id: String
    
    var representation: [String: Any] {
        var rep = ["username": username]
        rep["email"] = self.email
        rep["description"] = self.description
        rep["sex"] = self.sex
        rep["avatarStringURL"] = self.avatarStringURL
        rep["uid"] = self.id
        return rep
    }
    
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
