//
//  KeychainManager.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import Foundation
import Security
import CryptoKit

class KeychainManager {
    private let keychainKey: String = "com.daniel.aes.key"

    // Save a symmetric key to the Keychain
    func saveKey(_ key: SymmetricKey) -> Bool {
        let keyData = key.withUnsafeBytes { Data(Array($0)) }
        let query: [String: Any] = [
             kSecClass as String: kSecClassGenericPassword,
             kSecAttrAccount as String: keychainKey,  // Use a tag to identify the key
             kSecValueData as String: keyData,
             kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked // Specify accessibility
         ]
        
         // Delete any existing key with the same tag before adding the new key
         SecItemDelete(query as CFDictionary)
        
         let status = SecItemAdd(query as CFDictionary, nil)
         return status == errSecSuccess
    }

    // Retrieve the symmetric key from the Keychain
    func retrieveKey() -> SymmetricKey? {
        let query: [String: Any] = [
             kSecClass as String: kSecClassGenericPassword,
             kSecAttrAccount as String: keychainKey,
             kSecReturnData as String: true,
             kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
         ]
         var item: CFTypeRef?
         let status = SecItemCopyMatching(query as CFDictionary, &item)
        
         guard status == errSecSuccess, let keyData = item as? Data else {
             return nil
         }
         
         return SymmetricKey(data: keyData)
    }

    // Generate and store a new key if it does not already exist
    func generateAndStoreKey() {
        if retrieveKey() != nil {
            return
        }
        let key = SymmetricKey(size: .bits256)
        _ = saveKey(key)
    }
}
