//
//  MusicKitMonitor.swift
//  RecordCrate
//
//  Created by Andrew Januszko on 9/6/24.
//

import MusicKit
import Foundation
import os

/// A singleton thread-safe monitor for MusicKit that manages authorization and subscription status.
actor MusicKitMonitor: Monitor {
    
    /// Singleton instance of this actor that allows for global access.
    static let shared: MusicKitMonitor = MusicKitMonitor()
    
    /// A value that indicates the authorization status the user sets for the current app to access their Apple Music data.
    private(set) var authorizationStatus: MusicAuthorization.Status
    
    /// A boolean flag indicating if the user can become a subscriber to Apple Music.
    private(set) var canBecomeSubscriber: Bool
    
    /// A boolean flag indicating if the user can play catalog content from Apple Music.
    private(set) var canPlayCatalogContent: Bool
    
    /// A boolean flag indicating if the user has cloud library enabled for Apple Music.
    private(set) var hasCloudLibraryEnabled: Bool
    
    /// Internal value used to hold the monitor task while active.
    private var subscriptionUpdatesTask: Task<Void, Never>?
    
    /// A boolean flag indicating if the SubscriptionUpdates subservice has run atleast once.
    private(set) var subscriptionUpdatesTaskHasTriggered: Bool
    
    /// Interal value used to log the current status of the service.
    let logger: Logger
    
    /// Initalizer.
    private init() {
        self.authorizationStatus = .notDetermined
        self.subscriptionUpdatesTaskHasTriggered = false
        self.canBecomeSubscriber = true
        self.canPlayCatalogContent = false
        self.hasCloudLibraryEnabled = false
        self.subscriptionUpdatesTask = nil
        self.logger = BundleHelper.shared.logger(for: .musicKitAccessActor)
        self.logger.debug(":: init() | MusicKitAccessMonitor initialized.")
    }
    
    ///
    func start() async {
        self.subscriptionUpdatesTask?.cancel()
        self.subscriptionUpdatesTask = nil
        self.subscriptionUpdatesTaskHasTriggered = false
        let result = await MusicAuthorization.request()
        logger.debug(":: requestAuthorization() | MusicAuthorization.Status: \(result.description).")
        if result == .authorized {
            self.subscriptionUpdatesTask = Task {
                for await update in MusicSubscription.subscriptionUpdates {
                    self.canBecomeSubscriber = update.canBecomeSubscriber
                    self.canPlayCatalogContent = update.canPlayCatalogContent
                    self.hasCloudLibraryEnabled = update.hasCloudLibraryEnabled
                    self.subscriptionUpdatesTaskHasTriggered = true
                    logger.debug(":: startMonitoringSubscriptionUpdates() | canBecomeSubscriber: \(update.canBecomeSubscriber.description), canPlayCatalogContent: \(update.canPlayCatalogContent.description), hasCloudLibraryEnabled: \(update.hasCloudLibraryEnabled.description)")
                }
            }
        } else {
            logger.debug(":: start() | Subscription updates monitoring failed to start.")
        }
    }
    
    ///
    func stop() async {
        self.subscriptionUpdatesTask?.cancel()
        self.subscriptionUpdatesTask = nil
        self.subscriptionUpdatesTaskHasTriggered = false
        logger.debug(":: stop() | Subscription updates monitoring has stopped.")
    }
}
