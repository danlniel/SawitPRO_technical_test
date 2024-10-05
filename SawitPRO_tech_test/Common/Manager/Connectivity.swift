//
//  Connectivity.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import Combine
import SwiftUI
import Network

enum ConnectionType {
    case wifi
    case cellular
    case ethernet
    case unknown
}

final class Connectivity: ObservableObject {
    private var monitor: PathMonitoring
    private var cancellable: AnyCancellable?
    private var isMonitoring: Bool = false
    
    init() {
        monitor = DependencyContainer.shared.resolve(PathMonitoring.self)!
    }
    
    func start(completion: @escaping ((Bool, ConnectionType) -> Void)) {
        if isMonitoring { return } // Prevent starting it again if already started
        
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        isMonitoring = true
        
        monitor.pathUpdateHandler = { [weak self] path in
            guard let ws = self else { return }
            let isConnected = path.status == .satisfied
            let connectionType = ws.getConnectionType(path)
            
            DispatchQueue.main.async {
                completion(isConnected, connectionType)
            }
        }
    }
    
    // Stop monitoring the network changes
    func stopMonitoring() {
        if !isMonitoring { return } // Prevent stopping if not monitoring
        
        monitor.cancel()
        isMonitoring = false
    }
    
    // Determine the connection type
    private func getConnectionType(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else {
            return .unknown
        }
    }
}
