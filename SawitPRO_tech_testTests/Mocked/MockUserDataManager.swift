//
//  MockUserDataManager.swift
//  SawitPRO_tech_testTests
//
//  Created by Daniel Sunarjo on 05/10/24.
//

@testable import SawitPRO_tech_test
import Foundation
import Combine
import SwiftData

class MockUserDataManager: UserDataManagerProtocol {
    var users: [UserData] = []
    var shouldReturnError = false

    func create(model: UserData) -> AnyPublisher<Void, Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Creation Error"]))
                .eraseToAnyPublisher()
        }
        
        users.append(model)
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func fetch(using fetchRequest: FetchDescriptor<UserData>) -> AnyPublisher<[UserData], Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fetch Error"]))
                .eraseToAnyPublisher()
        }
        return Just(users).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func delete(model: UserData) -> AnyPublisher<Void, Error> {
        if let index = users.firstIndex(where: { $0.username == model.username }) {
            users.remove(at: index)
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Delete Error"])).eraseToAnyPublisher()
    }

    func fetchAll() -> AnyPublisher<[UserData], Error> {
        return Just(users).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
