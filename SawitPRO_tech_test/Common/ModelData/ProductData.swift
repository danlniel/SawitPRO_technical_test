//
//  ProductData.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import SwiftData

@Model
class ProductData {
    var name: String
    var price: Int

    init(name: String, price: Int) {
        self.name = name
        self.price = price
    }
}
