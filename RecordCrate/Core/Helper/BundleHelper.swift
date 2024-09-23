//
//  BundleHelper.swift
//  RecordCrate
//
//  Created by Andrew Januszko on 9/6/24.
//

import Foundation
import os

enum BundleError: Error {
    case invalidBundle
}

final class BundleHelper: Sendable {
    
    static let shared: BundleHelper = BundleHelper()
    
    var bundleIdentifier: Result<String, BundleError> {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            return .failure(.invalidBundle)
        }
        return .success(bundleIdentifier)
    }
    
    var internalName: Result<String, BundleError> {
        guard let internalName: String = Bundle.main.object(
            forInfoDictionaryKey: "CFBundleName"
        ) as? String else {
            return .failure(.invalidBundle)
        }
        return .success(internalName)
    }
    
    var buildNumber: Result<String, BundleError> {
        guard let buildNumber = Bundle.main.object(
            forInfoDictionaryKey: "CFBundleVersion"
        ) as? String else {
            return .failure(.invalidBundle)
        }
        return .success(buildNumber)
    }
    
    var versionNumber: Result<String, BundleError> {
        guard let versionNumber = Bundle.main.object(
            forInfoDictionaryKey: "CFBundleShortVersionString"
        ) as? String else {
            return .failure(.invalidBundle)
        }
        return .success(versionNumber)
    }
    
    func logger(for service: ServiceId) -> Logger {
        Logger(subsystem: "", category: service.rawValue)
    }
    
}
