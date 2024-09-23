//
//  UniversalBarButton.swift
//  RecordCrate
//
//  Created by Andrew Januszko on 9/22/24.
//

import SwiftUI
import PhosphorSwift
import Glur

struct UniversalBarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background {
                Group {
                    if configuration.isPressed {
                        Capsule()
                            .fill(Color.accentColor.opacity(0.5))
                            .blur(radius: 20)
                    }
                }
            }
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.smooth.speed(2), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == UniversalBarButtonStyle {
    static var universalBar: Self { UniversalBarButtonStyle() }
}

#Preview {
    Button(action: {
        
    }, label: {
        Ph.arrowLeft.bold
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 24)
    }).buttonStyle(.universalBar)
    
}
