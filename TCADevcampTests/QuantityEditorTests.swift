//
//  QuantityEditorTests.swift
//  TCADevcampTests
//
//  Created by jefferson.setiawan on 23/11/23.
//

import ComposableArchitecture
import XCTest
@testable import TCADevcamp

@MainActor
final class QuantityEditorTests: XCTestCase {
    func testTapPlus() async throws {
        let testStore = TestStore(initialState: QuantityEditor.State()) {
            QuantityEditor()
        }
        await testStore.send(.didTapPlus) {
            $0.qty = 1
        }
    }

    func testTapCheck() async throws {
        let testStore = TestStore(initialState: QuantityEditor.State()) {
            QuantityEditor()
        }
        
        testStore.dependencies.factCheckEnv.randomFactCheck = { "\($0) is fun" }
        
        await testStore.send(.didTapCheckFact)
        
        await testStore.receive(.receiveFact("0 is fun")) {
            $0.fact = "0 is fun"
        }
    }
    
    func testWhenChangeNumber_ShouldRemoveTheFactText() async throws {
        let testStore = TestStore(initialState: QuantityEditor.State(fact: "hehe")) {
            QuantityEditor()
        }
        
        await testStore.send(.didTapPlus) {
            $0.qty = 1
            $0.fact = nil
        }
    }
}
