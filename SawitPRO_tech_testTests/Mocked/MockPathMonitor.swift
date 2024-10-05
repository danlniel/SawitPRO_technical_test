//
//  MockPathMonitor.swift
//  SawitPRO_tech_testTests
//
//  Created by Daniel Sunarjo on 05/10/24.
//

@testable import SawitPRO_tech_test
import Network

class MockPathMonitor: PathMonitoring {
    var pathUpdateHandler: PathUpdateHandler?
    var isStarted = false
    
    init() {}
    
    func start(queue: DispatchQueue) {
        isStarted = true
    }
    
    func cancel() {
        isStarted = false
    }
    
    // Simulate a path update
    func simulatePathUpdate(path: NWPath) {
        pathUpdateHandler?(path)
    }
}
