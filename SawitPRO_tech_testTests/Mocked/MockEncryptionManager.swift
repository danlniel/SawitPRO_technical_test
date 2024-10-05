//
//  MockEncryptionManager.swift
//  SawitPRO_tech_testTests
//
//  Created by Daniel Sunarjo on 05/10/24.
//

@testable import SawitPRO_tech_test
import Foundation

class MockEncryptionManager: EncryptionManagerProtocol {
    var encryptResult: Result<String, Error>!
    var decryptResult: Result<String, Error>!

    func encrypt(string: String) -> Result<String, Error> {
        return encryptResult
    }

    func decrypt(string: String) -> Result<String, Error> {
        return decryptResult
    }
}
