//
//  Monitor.swift
//  RecordCrate
//
//  Created by Andrew Januszko on 9/9/24.
//

import Foundation
import os

///
protocol Monitor {
    
    ///
    var logger: Logger { get }
    
    ///
    func start() async
    
    ///
    func stop() async
}
