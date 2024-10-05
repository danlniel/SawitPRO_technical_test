//
//  DITestHelper.swift
//  SawitPRO_tech_testTests
//
//  Created by Daniel Sunarjo on 05/10/24.
//

@testable import SawitPRO_tech_test
import Foundation

struct DITestHelper {
    static func registerTestDependencies() {
        let di: DependencyContainer = .shared
        di.clear()
        
        // Default dependencies
        di.register({
            return MockPathMonitor()
        }, for: PathMonitoring.self)
        di.register({
            return MockModelContext()
        }, for: ModelContextProtocol.self)
        di.register({
            return MockUserDataManager()
        }, for: UserDataManagerProtocol.self)
        di.register({
            return MockEncryptionManager()
        }, for: EncryptionManagerProtocol.self)
        di.register({
            return KeychainManager()
        }, for: KeychainManager.self)
    }
}
