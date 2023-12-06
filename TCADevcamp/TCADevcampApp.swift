//
//  TCADevcampApp.swift
//  TCADevcamp
//
//  Created by jefferson.setiawan on 23/11/23.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCADevcampApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RouteView()
            }    
        }
    }
}
