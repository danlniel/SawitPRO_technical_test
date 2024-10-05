//
//  Factories.swift
//  SawitPRO_tech_testTests
//
//  Created by Daniel Sunarjo on 05/10/24.
//

@testable import SawitPRO_tech_test

struct Factories {
    static func createUserData() -> UserData {
        .init(username: "username", password: "password")
    }
}
