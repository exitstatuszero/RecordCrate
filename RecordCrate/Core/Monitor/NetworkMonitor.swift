//
//  NetworkMonitor.swift
//  RecordCrate
//
//  Created by Andrew Januszko on 9/6/24.
//

import Foundation
import Network
import os

actor NetworkMonitor {
    private(set) var networkMonitorHasTriggered: Bool
    private(set) var pathStatus: NWPath.Status
    private(set) var unsatisfiedReason: NWPath.UnsatisfiedReason
    private(set) var isExpensive: Bool
    private(set) var isConstrained: Bool
    private let networkMonitor: NWPathMonitor
    private let logger: Logger
    
    init() {
        self.networkMonitorHasTriggered = false
        self.pathStatus = .unsatisfied
        self.unsatisfiedReason = .notAvailable
        self.isExpensive = true
        self.isConstrained = true
        self.logger = BundleHelper.shared.logger(for: .networkStatusManager)
        self.logger.debug(":: init()")
        self.networkMonitor = NWPathMonitor()
        self.logger.debug(":: init() | NetworkManager initialized.")
    }
    
    func start() async {
        logger.debug(":: startMonitoringNetwork()")
        for await path in networkMonitor {
            self.pathStatus = path.status
            self.unsatisfiedReason = path.unsatisfiedReason
            self.isExpensive = path.isExpensive
            self.isConstrained = path.isConstrained
            self.networkMonitorHasTriggered = true
        }
        logger.debug(":: startMonitoringNetwork() | Network monitoring has started.")
    }
    
    func stop() {
        logger.debug(":: stopMonitoringNetwork()")
        self.networkMonitor.cancel()
        self.networkMonitorHasTriggered = false
        logger.debug(":: stopMonitoringNetwork() | Network monitoring has stopped.")
    }
}

