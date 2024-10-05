//
//  EncryptionManager.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 05/10/24.
//

import Foundation
import CryptoKit

enum EncryptionError: Error {
    case keyNotFound
    case invalidEncryption
    case invalidBase64
}

protocol EncryptionManagerProtocol {
    func encrypt(string: String) -> Result<String, Error>
    func decrypt(string: String) -> Result<String, Error>
}

final class EncryptionManager {
    private lazy var keychainManager: KeychainManager = {
        DependencyContainer.shared.resolve(KeychainManager.self)!
    }()

    // AES Encryption
    func encrypt(string: String) -> Result<String, Error> {
        guard let data = string.data(using: .utf8) else {
             return .failure(EncryptionError.invalidBase64)
         }
        
        guard let key = keychainManager.retrieveKey() else {
            return .failure(EncryptionError.keyNotFound)
        }
        
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            guard let combined = sealedBox.combined else {
                return .failure(EncryptionError.invalidEncryption)
            }
            return .success(combined.base64EncodedString())
        } catch {
            return .failure(error)
        }
    }

    // AES Decryption
    func decrypt(string: String) -> Result<String, Error> {
        guard let cipherData = Data(base64Encoded: string),
              let key = keychainManager.retrieveKey() else {
            return .failure(EncryptionError.invalidBase64)
        }
        
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: cipherData)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            
            if let decryptedString = String(data: decryptedData, encoding: .utf8) {
                return .success(decryptedString)
            } else {
                return .failure(EncryptionError.invalidBase64)
            }
        } catch {
            return .failure(error)
        }
    }
}

extension EncryptionManager: EncryptionManagerProtocol {}
