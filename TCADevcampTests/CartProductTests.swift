//
//  CartProductTests.swift
//  TCADevcampTests
//
//  Created by jefferson.setiawan on 06/12/23.
//

import ComposableArchitecture
import XCTest
@testable import TCADevcamp

@MainActor
final class CartProductTests: XCTestCase {
    func testChangeToggleIsActive() async throws {
        let testStore = TestStore(initialState: CartProduct.State(id: UUID(), name: "A", price: 10_000, qtyEditorState: QuantityEditor.State(qty: 1))) {
            CartProduct()
        }
        
        await testStore.send(.didTapToggle(false)) {
            $0.isChecked = false
        }
    }
}
