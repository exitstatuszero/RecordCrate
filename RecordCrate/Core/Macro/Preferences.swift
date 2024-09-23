//
//  Preferences.swift
//  RecordCrate
//
//  Created by Andrew Januszko on 9/15/24.
//

import Foundation

@propertyWrapper
struct Preferences<T: Codable> {
    private let key: String
    private var storage: UserDefaults
    
    var wrappedValue: T {
        get {
            // Attempt to retrieve the value from UserDefaults
            if let data = storage.data(forKey: key),
               let value = try? JSONDecoder().decode(T.self, from: data) {
                return value
            }
            // If not found, return a default-initialized value (set by the variable)
            fatalError("No value found in UserDefaults and no default value provided")
        }
        set {
            // Encode the new value and save it to UserDefaults
            if let data = try? JSONEncoder().encode(newValue) {
                storage.set(data, forKey: key)
            }
        }
    }
    
    // Automatically initialize from wrappedValue
    init(wrappedValue: T, _ key: PreferencesKey, storage: UserDefaults = .standard) {
        self.key = key.rawValue
        self.storage = storage
        
        // If no value exists in storage, store the default value
        if storage.object(forKey: key.rawValue) == nil {
            self.wrappedValue = wrappedValue
        }
    }
}

