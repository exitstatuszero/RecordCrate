//
//  BundleHelper.swift
//  RecordCrate
//
//  Created by Andrew Januszko on 9/6/24.
//

import Foundation
import os

/// Class used to fetch bundle information for RecordCrate.
final class BundleHelper: Sendable {
    static let shared: BundleHelper = BundleHelper()
    let bundleIdentifier: String
    let internalName: String
    let versionNumber: String
    let buildNumber: String
    
    private init() {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            fatalError("Failed to retrieve bundle identifier from Info.plist for RecordCrate.")
        }
        self.bundleIdentifier = bundleIdentifier
        
        guard let internalName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else {
            fatalError("Failed to retrieve internal name from Info.plist for RecordCrate.")
        }
        self.internalName = internalName
        
        guard let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            fatalError("Failed to retrieve build number from Info.plist for RecordCrate.")
        }
        self.buildNumber = buildNumber
        
        guard let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            fatalError("Failed to retrieve version number from Info.plist for RecordCrate.")
        }
        self.versionNumber = versionNumber
    }
    
    func logger(for service: ServiceId) -> Logger {
        Logger(subsystem: self.bundleIdentifier, category: service.rawValue)
    }
    
}
