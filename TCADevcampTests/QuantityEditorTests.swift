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
            $0.qtyString = "1"
            $0.qty = 1
        }
    }
    
    func testTapPlus_WhenExceedMaxQty_CannotIncrement() async throws {
        let testStore = TestStore(initialState: QuantityEditor.State(qty: 2, maxQty: 2)) {
            QuantityEditor()
        }
        await testStore.send(.didTapPlus) {
            $0.errorMessage = "Exceed max quantity"
        }
    }
    
    func testTapMinus() async throws {
        let testStore = TestStore(initialState: QuantityEditor.State(qty: 2)) {
            QuantityEditor()
        }
        await testStore.send(.didTapMinus) {
            $0.qty = 1
            $0.qtyString = "1"
        }
    }
    
    func testWhenChangeToValidQuantity_ShouldRemoveTheErrorMessage() async throws {
        let testStore = TestStore(initialState: QuantityEditor.State()) {
            QuantityEditor()
        }
        
        await testStore.send(.didTapMinus) {
            $0.errorMessage = "Below min quantity"
        }
        
        await testStore.send(.didTapPlus) {
            $0.qty = 1
            $0.qtyString = "1"
            $0.errorMessage = nil
        }
    }
    
    func testChangeQuantityViaTextField() async throws {
        let testStore = TestStore(initialState: QuantityEditor.State()) {
            QuantityEditor()
        }
        
        await testStore.send(.didChangeText("10")) {
            $0.qty = 10
            $0.qtyString = "10"
        }
    }
    
    func testChangeQuantityViaTextField_WhenTypeNonNumeric_ShouldShowError() async throws {
        let testStore = TestStore(initialState: QuantityEditor.State()) {
            QuantityEditor()
        }
        
        await testStore.send(.didChangeText("a")) {
            $0.qtyString = "a"
            $0.errorMessage = "Quantity should be a number"
        }
    }
    
    func testChangeQuantityViaTextField_WhenTypeQtyGreaterThanMaxQty_ShouldShowError() async throws {
        let testStore = TestStore(initialState: QuantityEditor.State(maxQty: 2)) {
            QuantityEditor()
        }
        
        await testStore.send(.didChangeText("3")) {
            $0.qtyString = "3"
            $0.errorMessage = "Exceed max quantity"
        }
    }
    
    func testIsButtonPlusDisabledValidation() {
        var state = QuantityEditor.State(qty: 1, minQty: 1, maxQty: 2)
        XCTAssertFalse(state.isPlusButtonDisabled)
        state.qty = 2
        XCTAssertTrue(state.isPlusButtonDisabled)
        state.qty = 3
        XCTAssertTrue(state.isPlusButtonDisabled)
    }
    
    func testIsButtonMinusDisabledValidation() {
        var state = QuantityEditor.State(qty: 1, minQty: 2)
        XCTAssertTrue(state.isMinusButtonDisabled)
        state.qty = 2
        XCTAssertTrue(state.isMinusButtonDisabled)
        state.qty = 3
        XCTAssertFalse(state.isMinusButtonDisabled)
    }
}
