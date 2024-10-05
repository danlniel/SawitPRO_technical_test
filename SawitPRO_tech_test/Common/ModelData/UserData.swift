//
//  User.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import SwiftData

@Model
class UserData {
    var username: String
    var password: String

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
