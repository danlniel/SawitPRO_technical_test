//
//  MockLoginRepository.swift
//  SawitPRO_tech_testTests
//
//  Created by Daniel Sunarjo on 05/10/24.
//

@testable import SawitPRO_tech_test
import Foundation
import Combine

class MockLoginRepository: LoginRepositoryProtocol {
    var shouldFailFetch = false
    var shouldFailRegister = false
    var users: [UserData] = []
    
    func register(username: String, password: String) -> AnyPublisher<Void, Error> {
        if shouldFailRegister {
            return Fail(error: NSError(domain: "MockError", code: 1, userInfo: nil))
                .eraseToAnyPublisher()
        }
        let newUser = UserData(username: username, password: password)
        users.append(newUser)
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func fetchWithUsername(username: String) -> AnyPublisher<[UserData], Error> {
        if shouldFailFetch {
            return Fail(error: NSError(domain: "MockError", code: 1, userInfo: nil))
                .eraseToAnyPublisher()
        }
        return Just(users.filter { $0.username == username })
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
