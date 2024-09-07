//
//  UtilityStore.swift
//  RecordCrate
//
//  Created by Andrew Januszko on 9/6/24.
//

import Foundation

@Observable
final class UtilityStore {
    let musicKitAccessMonitor: MusicKitAccessMonitor
    let networkMonitor: NetworkMonitor

    init(
        musicKitAccessMonitor: MusicKitAccessMonitor = MusicKitAccessMonitor(),
        networkMonitor: NetworkMonitor = NetworkMonitor()
    ) {
        self.musicKitAccessMonitor = musicKitAccessMonitor
        self.networkMonitor = networkMonitor
    }
}
