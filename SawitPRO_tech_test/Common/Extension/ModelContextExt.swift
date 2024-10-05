//
//  ModelContextExt.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 05/10/24.
//

import SwiftData

protocol ModelContextProtocol {
    func insert<T: PersistentModel>(_ model: T)
    func fetch<T: PersistentModel>(_ fetchDescriptor: FetchDescriptor<T>) throws -> [T]
    func delete<T: PersistentModel>(_ model: T)
    func save() throws
}

extension ModelContext: ModelContextProtocol {}
