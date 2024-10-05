//
//  ConnectivitySpec.swift
//  SawitPRO_tech_testTests
//
//  Created by Daniel Sunarjo on 05/10/24.
//

@testable import SawitPRO_tech_test
import XCTest
import Network

final class ConnectivityTests: XCTestCase {
    var connectivity: Connectivity!
    var mockMonitor: MockPathMonitor!
    let di: DependencyContainer = .shared

    override func setUp() {
        super.setUp()
        prepareDependencies()
    }

    func testStartMonitoring() {
        connectivity.start { _, _ in
            // NWPath is created by iOS runtime and cannot be mocked for testing purposes
        }
        XCTAssertTrue(mockMonitor.isStarted, "The mock monitor should start monitoring")
    }
    
    func testStopMonitoring() {
        connectivity.start { _, _ in }
        connectivity.stopMonitoring()
        
        XCTAssertFalse(mockMonitor.isStarted, "The mock monitor should stop monitoring")
    }
    
    private func prepareDependencies() {
        DITestHelper.registerTestDependencies()
        
        mockMonitor = .init()
        di.register({
            self.mockMonitor
        }, for: PathMonitoring.self)
        
        connectivity = .init()
    }
}
