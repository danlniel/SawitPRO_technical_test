//
//  FirestoreModel.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import Foundation

protocol FirestoreModel: Identifiable {
    var id: String { get set }
    init?(from dictionary: [String: Any])
    func toDictionary() -> [String: Any]
}
