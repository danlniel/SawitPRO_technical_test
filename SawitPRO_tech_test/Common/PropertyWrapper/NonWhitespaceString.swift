//
//  NonWhitespaceString.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

@propertyWrapper
struct NonWhitespaceString {
    private var value: String

    var wrappedValue: String {
        get { value }
        set {
            value = newValue.replacingOccurrences(of: " ", with: "")
        }
    }

    init(wrappedValue: String) {
        self.value = wrappedValue.replacingOccurrences(of: " ", with: "")
    }
}
