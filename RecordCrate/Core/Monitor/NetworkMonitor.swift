//
//  NetworkMonitor.swift
//  RecordCrate
//
//  Created by Andrew Januszko on 9/6/24.
//

import Network
import Foundation
import os

///
actor NetworkMonitor: Monitor {
    
    ///
    static let shared: NetworkMonitor = NetworkMonitor()
    
    ///
    private(set) var networkMonitorHasTriggered: Bool
    
    ///
    private(set) var pathStatus: NWPath.Status
    
    ///
    private(set) var unsatisfiedReason: NWPath.UnsatisfiedReason
    
    ///
    private(set) var isExpensive: Bool
    
    ///
    private(set) var isConstrained: Bool
    
    ///
    private let networkMonitor: NWPathMonitor
    
    ///
    let logger: Logger
    
    ///
    private init() {
        self.networkMonitorHasTriggered = false
        self.pathStatus = .unsatisfied
        self.unsatisfiedReason = .notAvailable
        self.isExpensive = true
        self.isConstrained = true
        self.logger = BundleHelper.shared.logger(for: .networkStatusActor)
        self.networkMonitor = NWPathMonitor()
        self.logger.debug(":: init() | NetworkManager initialized.")
    }
    
    ///
    func start() async {
        self.networkMonitor.cancel()
        self.networkMonitorHasTriggered = false
        for await path in networkMonitor {
            self.pathStatus = path.status
            self.unsatisfiedReason = path.unsatisfiedReason
            self.isExpensive = path.isExpensive
            self.isConstrained = path.isConstrained
            self.networkMonitorHasTriggered = true
        }
        logger.debug(":: start() | Network monitoring has started.")
    }
    
    ///
    func stop() async {
        self.networkMonitor.cancel()
        self.networkMonitorHasTriggered = false
        logger.debug(":: stop() | Network monitoring has stopped.")
    }
}

