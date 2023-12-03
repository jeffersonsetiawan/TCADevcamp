//
//  TCADevcampTests.swift
//  TCADevcampTests
//
//  Created by jefferson.setiawan on 23/11/23.
//

import ComposableArchitecture
import XCTest
@testable import TCADevcamp

@MainActor
final class TCADevcampTests: XCTestCase {
    func testExample() async throws {
        let testStore = TestStore(initialState: DevcampApp.State(a: 10)) {
            DevcampApp()
        }
        await testStore.send(.didAppear) {
            $0.a = 11
        }
    }
}
