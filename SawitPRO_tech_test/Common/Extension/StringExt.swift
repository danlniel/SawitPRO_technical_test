//
//  StringExt.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import CryptoKit
import Foundation

extension String {
    var encryptionManager: EncryptionManagerProtocol {
        return DependencyContainer.shared.resolve(EncryptionManagerProtocol.self)!
    }
    
    func encrypt() -> Result<String, Error> {
         return encryptionManager.encrypt(string: self)
    }
    
    func decrypt() -> Result<String, Error> {
        return encryptionManager.decrypt(string: self)
    }
    
    func toInt() -> Int {
        Int(self) ?? 0
    }
    
    func toRupiah() -> String {
        guard let value = Int(self) else { return "" }

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "IDR" // Indonesian Rupiah
        formatter.locale = Locale(identifier: "id_ID") // Indonesian locale

        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    static func localized(_ key: String) -> String {
        LocalizedManager.shared.localizedString(forKey: key)
    }
}
