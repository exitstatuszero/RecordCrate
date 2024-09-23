//
//  OnboardingView.swift
//  RecordCrate
//
//  Created by Andrew Januszko on 9/13/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @Preferences(.isFirstLaunch)
    private var isFirstLaunch: Bool = false
    
    
    var body: some View {
        TabView {
            Text("A")
            Text("B")
            Text("C")
            Text("D")
        }
        
    }
}

#Preview {
    OnboardingView()
}
