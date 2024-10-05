//
//  LocalizedManager.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import Foundation

class LocalizedManager {
    static let shared = LocalizedManager()
    
    private init() {}
    
    // Function to retrieve localized string
    func localizedString(forKey key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    // Optionally, you can add a function to retrieve localized string with a specific comment
    func localizedString(forKey key: String, comment: String) -> String {
        return NSLocalizedString(key, comment: comment)
    }
}

// Debt align thiese all to use camel/snack case
struct LocalizableKeys {
    static let username = "Username"
    static let password = "Password"
    static let login = "Login"
    static let register = "Register"
    static let home = "Home"
    static let search = "Search..."
    static let online = "Online"
    static let offline = "Offline"
    static let syncing = "Syncing"
    static let productHasbeenAdded = "product_has_been_added"
    static let loginFailed = "login_failed"
    static let loginSuccess = "login_success"
    static let failedProcessData = "failed_process_data"
    static let usernameHasBeenRegistered = "username_has_been_registered"
    static let failedAddUser = "failed_add_user"
    static let userHasBeenAdded = "user_has_been_added"
    static let failedAddProduct = "failed_add_product"
    static let productHasBeenDeleted = "product_has_been_deleted"
    static let failedRemoveProduct = "failed_remove_product"
    static let productHasBeenUpdated = "product_has_been_updated"
    static let failedUpdateProduct = "failed_update_product"
    static let syncFailed = "sync_failed"
    static let syncSuccess = "sync_success"
}

struct RegisteredImage {
    static let logo = "logo"
    static let plus = "plus"
    static let miniCircle = "line.horizontal.3.decrease.circle"
}
