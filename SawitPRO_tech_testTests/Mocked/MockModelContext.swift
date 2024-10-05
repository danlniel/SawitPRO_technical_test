//
//  MockModelContext.swift
//  SawitPRO_tech_testTests
//
//  Created by Daniel Sunarjo on 05/10/24.
//

@testable import SawitPRO_tech_test
import Foundation
import SwiftData

class MockModelContext: ModelContextProtocol {
    var models: [String: Any] = [:]
    var saveCalled = false
    var fetchError: Error?

    func insert<T: PersistentModel>(_ model: T) {
        models[String(describing: T.self)] = model
    }
    
    func fetch<T: PersistentModel>(_ fetchDescriptor: FetchDescriptor<T>) throws -> [T] {
        if let error = fetchError {
            throw error
        }
        return models.values.compactMap { $0 as? T }
    }

    func delete<T: PersistentModel>(_ model: T) {
        models.removeValue(forKey: String(describing: T.self))
    }

    func save() throws {
        saveCalled = true
    }
}
