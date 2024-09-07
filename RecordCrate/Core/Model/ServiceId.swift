//
//  ServiceId.swift
//  RecordCrate
//
//  Created by Andrew Januszko on 9/6/24.
//

import Foundation

enum ServiceId: String, CaseIterable, Hashable {
    case bundleInfoHelper = "BundleInfoHelper"
    case musicKitAccessManager = "MusicKitAccessActor"
    case networkStatusManager = "NetworkStatusActor"
}
