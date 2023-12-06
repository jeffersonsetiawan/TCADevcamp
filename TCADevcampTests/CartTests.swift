//
//  CartTests.swift
//  TCADevcampTests
//
//  Created by jefferson.setiawan on 06/12/23.
//

import ComposableArchitecture
import XCTest
@testable import TCADevcamp

@MainActor
final class CartTests: XCTestCase {
    func testDidLoad_ShouldGetCart() async throws {
        let testStore = TestStore(initialState: Cart.State()) {
            Cart()
        }
        let mockCart = [
            CartProduct.State(
                id: UUID(),
                name: "",
                price: 1,
                qtyEditorState: QuantityEditor.State()
            )
        ]
        
        testStore.dependencies.cartEnv.getCart = {
            mockCart
        }
        
        await testStore.send(.didLoad)
        
        await testStore.receive(.receiveCart(mockCart)) {
            $0.items = IdentifiedArrayOf(uniqueElements: mockCart)
        }
    }
    
    func testTotalPrice() {
        let item1 = CartProduct.State(
            id: UUID(),
            name: "a",
            price: 10,
            qtyEditorState: QuantityEditor.State(qty: 2)
        )
        let item2 = CartProduct.State(
            id: UUID(),
            name: "b",
            price: 1,
            qtyEditorState: QuantityEditor.State(qty: 3)
        )
        var state = Cart.State(items: [
            item1, item2
        ])
        XCTAssertEqual(state.totalPrice, 23)
        state.items[id: item1.id]?.isChecked = false
        XCTAssertEqual(state.totalPrice, 3)
        
        state.items[id: item2.id]?.qtyEditorState.qty = 5
        XCTAssertEqual(state.totalPrice, 5)
    }
}
