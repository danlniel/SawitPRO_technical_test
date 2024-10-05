//
//  SawitPRO_tech_testApp.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        return true
    }
}

@main
struct SawitPROApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    private let di: DependencyContainer = .shared
    private lazy var keychainManager: KeychainManager = {
        DependencyContainer.shared.resolve(KeychainManager.self)!
    }()
    
    init() {
        di.registerDependencies()
        registerFirebase()
        keychainManager.generateAndStoreKey()
    }
    
    var body: some Scene {
        WindowGroup {
            RootCoordinator()
                .modelContainer(for: [UserData.self, ProductData.self])
        }
    }
    
    private func registerFirebase() {
        FirebaseApp.configure()
    }
}
