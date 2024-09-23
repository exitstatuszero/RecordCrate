//
//  ServiceId.swift
//  RecordCrate
//
//  Created by Andrew Januszko on 9/6/24.
//

import Foundation

///
enum ServiceId: String, CaseIterable, Hashable {
    
    ///
    case bundleHelper = "BundleHelper"
    
    ///
    case musicKitAccessActor = "MusicKitAccessActor"
    
    ///
    case networkStatusActor = "NetworkStatusActor"
}
