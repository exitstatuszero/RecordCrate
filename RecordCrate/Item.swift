//
//  Item.swift
//  RecordCrate
//
//  Created by Andrew Januszko on 9/6/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
