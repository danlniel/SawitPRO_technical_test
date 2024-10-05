//
//  UserDataManager.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 05/10/24.
//

import Combine
import SwiftData

protocol UserDataManagerProtocol {
    func create(model: UserData) -> AnyPublisher<Void, Error>
    func fetch(using fetchRequest: FetchDescriptor<UserData>) -> AnyPublisher<[UserData], Error>
    func delete(model: UserData) -> AnyPublisher<Void, Error>
    func fetchAll() -> AnyPublisher<[UserData], Error>
}

class UserDataManager: UserDataManagerProtocol {
    private lazy var dataManager: SwiftDataManager<UserData> = {
        DependencyContainer.shared.resolve(SwiftDataManager<UserData>.self)!
    }()

    func create(model: UserData) -> AnyPublisher<Void, Error> {
        return dataManager.create(model: model)
    }

    func fetch(using fetchRequest: FetchDescriptor<UserData>) -> AnyPublisher<[UserData], Error> {
        return dataManager.fetch(using: fetchRequest)
    }

    func delete(model: UserData) -> AnyPublisher<Void, Error> {
        return dataManager.delete(model: model)
    }

    func fetchAll() -> AnyPublisher<[UserData], Error> {
        return dataManager.fetchAll()
    }
}
