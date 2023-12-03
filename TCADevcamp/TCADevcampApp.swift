//
//  TCADevcampApp.swift
//  TCADevcamp
//
//  Created by jefferson.setiawan on 23/11/23.
//

import ComposableArchitecture
import SwiftUI

struct DevcampApp: Reducer {
    struct State: Equatable {
        var a = 0
    }
    
    enum Action {
        case didAppear
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didAppear:
            state.a += 1
            return .none
        }
    }
}

@main
struct TCADevcampApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
