//
//  MusicKitAccessMonitor.swift
//  RecordCrate
//
//  Created by Andrew Januszko on 9/6/24.
//

import Foundation
import MusicKit
import os

actor MusicKitAccessMonitor {
    private(set) var authorizationStatus: MusicAuthorization.Status
    private(set) var subscriptionUpdatesTaskHasTriggered: Bool
    private(set) var canBecomeSubscriber: Bool
    private(set) var canPlayCatalogContent: Bool
    private(set) var hasCloudLibraryEnabled: Bool
    private var subscriptionUpdatesTask: Task<Void, Never>?
    private let logger: Logger
    
    init() {
        self.authorizationStatus = .notDetermined
        self.subscriptionUpdatesTaskHasTriggered = false
        self.canBecomeSubscriber = true
        self.canPlayCatalogContent = false
        self.hasCloudLibraryEnabled = false
        self.subscriptionUpdatesTask = nil
        self.logger = BundleHelper.shared.logger(for: .musicKitAccessManager)
    }
    
    func requestAuthorization() async -> MusicAuthorization.Status {
        logger.debug(":: requestAuthorization()")
        let result = await MusicAuthorization.request()
        logger.debug(":: requestAuthorization() | MusicAuthorization.Status: \(result.description).")
        self.authorizationStatus = result
        return result
    }
    
    func start() async {
        logger.debug(":: startMonitoringSubscriptionUpdates()")
        self.subscriptionUpdatesTask = Task {
            for await update in MusicSubscription.subscriptionUpdates {
                logger.debug(":: startMonitoringSubscriptionUpdates() | canBecomeSubscriber: \(update.canBecomeSubscriber.description), canPlayCatalogContent: \(update.canPlayCatalogContent.description), hasCloudLibraryEnabled: \(update.hasCloudLibraryEnabled.description)")
                self.canBecomeSubscriber = update.canBecomeSubscriber
                self.canPlayCatalogContent = update.canPlayCatalogContent
                self.hasCloudLibraryEnabled = update.hasCloudLibraryEnabled
                self.subscriptionUpdatesTaskHasTriggered = true
            }
        }
        logger.debug(":: startMonitoringSubscriptionUpdates() | Subscription updates monitoring has started.")
    }

    func stop() {
        logger.debug(":: stopMonitoringSubscriptionUpdates()")
        self.subscriptionUpdatesTask?.cancel()
        self.subscriptionUpdatesTask = nil
        self.subscriptionUpdatesTaskHasTriggered = false
        logger.debug(":: stopMonitoringSubscriptionUpdates() | Subscription updates monitoring has stopped.")
    }
}
