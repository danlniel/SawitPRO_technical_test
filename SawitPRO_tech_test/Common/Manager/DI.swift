//
//  DI.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import Foundation
import Network
import SwiftData

final class DependencyContainer {
    static let shared: DependencyContainer = .init()
    // A dictionary to store service factories and instances
    private var serviceFactories: [String: () -> Any] = [:]
    private var registeredInstances: [String: Any] = [:]

    // Register a service instance
    func register<T>(_ instance: T, for type: T.Type) {
        let key = String(describing: type)
        registeredInstances[key] = instance
    }

    // Register a service using a factory closure
    func register<T>(_ factory: @escaping () -> T, for type: T.Type) {
        let key = String(describing: type)
        serviceFactories[key] = factory
    }

    // Retrieve a service (either a new instance or a registered instance)
    func resolve<T>(_ type: T.Type) -> T? {
        let key = String(describing: type)
        
        // First, check if there is a registered instance
        if let instance = registeredInstances[key] as? T {
            return instance
        }

        // If not, check if there is a factory closure and call it
        return serviceFactories[key]?() as? T
    }
    
    // Clear all instances and factories that are registered.
    func clear() {
        serviceFactories = [:]
        registeredInstances = [:]
    }
}

extension DependencyContainer {
    func registerDependencies() {
        register({
            return SwiftDataManager<UserData>()
        }, for: SwiftDataManager<UserData>.self)
        register({
            return UserDataManager()
        }, for: UserDataManagerProtocol.self)
        register({
            return SwiftDataManager<ProductData>()
        }, for: SwiftDataManager<ProductData>.self)
        register({
            return LoginRepository()
        }, for: LoginRepositoryProtocol.self)
        register({
            return LoginViewModel()
        }, for: LoginViewModel.self)
        register({
            return HomeRepository()
        }, for: HomeRepositoryProtocol.self)
        register({
            return HomeViewModel()
        }, for: HomeViewModel.self)
        register({
            return Connectivity()
        }, for: Connectivity.self)
        register({
            return FirestoreManager<ProductFM>(collectionName: "product")
        }, for: FirestoreManager<ProductFM>.self)
        register({
            return KeychainManager()
        }, for: KeychainManager.self)
        register({
            return EncryptionManager()
        }, for: EncryptionManagerProtocol.self)
        register({
            return NWPathMonitor()
        }, for: PathMonitoring.self)
    }
    
    func registerContext(context: ModelContext) {
        register({ context }, for: ModelContextProtocol.self)
    }
}
