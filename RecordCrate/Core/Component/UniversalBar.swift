//
//  UniversalBar.swift
//  RecordCrate
//
//  Created by Andrew Januszko on 9/20/24.
//

import SwiftUI
import PhosphorSwift

struct UBAction: Hashable {
    let icon: Ph
    let action: () -> Void
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(icon)
    }
    
    static func == (lhs: UBAction, rhs: UBAction) -> Bool {
        lhs.icon == rhs.icon
    }
}

struct UBState: Hashable {
    let title: String
    let subtitle: String
    let allowSearch: Bool
    let onBack: () -> Void
    let actions: [UBAction]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(subtitle)
        hasher.combine(allowSearch)
        hasher.combine(actions)
    }
    
    static func == (lhs: UBState, rhs: UBState) -> Bool {
        lhs.title == rhs.title &&
        lhs.subtitle == rhs.subtitle &&
        lhs.allowSearch == rhs.allowSearch &&
        lhs.actions == rhs.actions
    }
}

@Observable
class UniversalBarManager {
    
    private(set) var stack: [UBState]
    
    init() {
        self.stack = []
    }
    
    func push(_ bar: UBState) {
        stack.append(bar)
    }
    
    func pop() -> UBState {
        stack.removeLast()
    }
}



struct UniversalBar: View {
    @Environment(UniversalBarManager.self)
    private var manager: UniversalBarManager
    
    var body: some View {
        
        let currentState: UBState? = manager.stack.last
        
        Group {
            if (currentState == nil) {
                EmptyView()
            } else {
                _UniversalBar(state: currentState!)
            }
        }
    }
}

private struct _UniversalBar: View {
    
    @Environment(UniversalBarManager.self)
    private var manager: UniversalBarManager
    
    @Preferences(.preferBackOnRight)
    private var preferBackOnRight: Bool = false
    
    let state: UBState
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.thickMaterial)
                .shadow(color: .black.opacity(0.25), radius: 6.25)
            VStack(alignment: .leading, spacing: 25) {
                VStack(alignment: .leading) {
                    Text(state.title)
                        .fontWeight(.semibold)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(state.subtitle)
                }
                HStack(alignment: .center) {
                    if (!preferBackOnRight) {
                        Button(action: {
                            state.onBack()
                        }, label: {
                            Ph.arrowLeft.bold
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(maxWidth: 24)
                        }).buttonStyle(.universalBar)
                        Spacer()
                    }
                    ForEach(state.actions, id: \.self) { action in
                        Button(action: {
                            action.action()
                        }, label: {
                            action.icon.bold
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(maxWidth: 24)
                        }).buttonStyle(.universalBar)
                        if action != state.actions.last {
                            Spacer()
                        }
                    }
                    if (preferBackOnRight) {
                        Spacer()
                        Button(action: {
                            manager.stack.last?.onBack()
                        }, label: {
                            Ph.arrowLeft.bold
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(maxWidth: 24)
                        }).buttonStyle(.universalBar)
                    }
                    
                }
            }
            .padding(25)
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: 500)
    }
}



#Preview {
    
    @Previewable
    @State
    var universalBarManager: UniversalBarManager = UniversalBarManager()
    universalBarManager.push(UBState(title: "Title1", subtitle: "Subtitle1", allowSearch: false, onBack: {}, actions: [
        .init(icon: .calendarPlus, action: {}),
        .init(icon: .bell, action: {}),
        .init(icon: .star, action: {})
    ]))
    
    
    return VStack {
        Spacer()
        Button("Push") {
            universalBarManager.push(UBState(title: "Title2", subtitle: "Subtitle2", allowSearch: true, onBack: {}, actions: [
                .init(icon: .export, action: {}),
                .init(icon: .copy, action: {})
            ]))
        }.buttonStyle(.bordered)
        Spacer()
        Button("Pop") {
            let _ = universalBarManager.pop()
        }.buttonStyle(.bordered)
        Spacer()
        
        UniversalBar()
            .padding(12.5)
    }
    .environment(universalBarManager)
}
