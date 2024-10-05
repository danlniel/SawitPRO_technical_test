//
//  User.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

struct User {
    @NonWhitespaceString var username: String
    @NonWhitespaceString var password: String

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    func encryptedPassword() -> String {
        let encryptionResult = password.encrypt()
        if case let .success(encryptedString) = encryptionResult {
            return encryptedString
        }
        return ""
    }
}
