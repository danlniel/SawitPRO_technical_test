//
//  NWPathMonitorExt.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 05/10/24.
//

import Network

protocol PathMonitoring {
    typealias PathUpdateHandler = @Sendable (NWPath) -> Void
    
    var pathUpdateHandler: PathUpdateHandler? { get set }
    func start(queue: DispatchQueue)
    func cancel()
}

extension NWPathMonitor: PathMonitoring {}
