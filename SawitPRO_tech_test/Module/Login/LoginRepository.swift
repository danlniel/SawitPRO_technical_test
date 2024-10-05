//
//  LoginRepository.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import Foundation
import SwiftData
import Combine

protocol LoginRepositoryProtocol {
    func register(username: String, password: String) -> AnyPublisher<Void, Error>
    func fetchWithUsername(username: String) -> AnyPublisher<[UserData], Error>
}

class LoginRepository: ObservableObject {
    private lazy var dataManager: UserDataManagerProtocol = {
        DependencyContainer.shared.resolve(UserDataManagerProtocol.self)!
    }()
    
    func register(username: String, password: String) -> AnyPublisher<Void, Error> {
        let newUser: UserData = .init(username: username, password: password)
        return dataManager.create(model: newUser)
    }
    
    func fetchWithUsername(username: String) -> AnyPublisher<[UserData], Error> {
        let fetchRequest: FetchDescriptor<UserData> = .init(
            predicate: #Predicate { $0.username == username }
        )
        return dataManager.fetch(using: fetchRequest)
    }
}

extension LoginRepository: LoginRepositoryProtocol {}
