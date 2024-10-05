//
//  ProductFM.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import Foundation

struct ProductFM: FirestoreModel {
    var id: String = UUID().uuidString
    var name: String
    var price: Int
    
    // To initialize from Firestore's data dictionary
    init?(from dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let name = dictionary["name"] as? String,
              let price = dictionary["price"] as? Int else {
            return nil
        }
        self.id = id
        self.name = name
        self.price = price
    }

    init(name: String, price: Int) {
        self.name = name
        self.price = price
    }
    
    init(id: String, name: String, price: Int) {
        self.id = id
        self.name = name
        self.price = price
    }
    
    // Convert the model into a dictionary for Firestore
    func toDictionary() -> [String: Any] {
        return ["name": name, "price": price]
    }
}
