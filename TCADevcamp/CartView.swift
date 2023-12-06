//
//  CartView.swift
//  TCADevcamp
//
//  Created by jefferson.setiawan on 23/11/23.
//

import CasePaths
import ComposableArchitecture
import SwiftUI

struct Cart: Reducer {
    struct State: Equatable {
        var items: IdentifiedArrayOf<CartProduct.State> = []
        @PresentationState var addProductState: AddProduct.State?
        var totalPrice: Int {
            items
                .filter(\.isChecked)
                .map { $0.price * $0.qtyEditorState.qty }
                .reduce(0, +)
        }
    }
    
    enum Action: Equatable {
        case didLoad
        case didTapAddItem
        case receiveCart([CartProduct.State])
        case products(id: UUID, action: CartProduct.Action)
        case addProduct(PresentationAction<AddProduct.Action>)
    }
    
    @Dependency(\.cartEnv) var env
    
    var body: some ReducerOf<Self> {
        Reduce(self.core)
            .forEach(\.items, action: /Action.products) {
                CartProduct()
            }
            .ifLet(\.$addProductState, action: /Action.addProduct) {
                AddProduct()
            }
    }
    
    func core(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didLoad:
            return .run { send in
                try await send(.receiveCart(env.getCart()))
            }
        case .didTapAddItem:
            state.addProductState = AddProduct.State(id: UUID())
            return .none
        case let .receiveCart(items):
            state.items = IdentifiedArray(uniqueElements: items)
            return .none
        case .products:
            return .none
        case .addProduct(.presented(.addItemEffect(let newItem))):
            state.items.append(CartProduct.State(id: newItem.id, name: newItem.name, price: newItem.price, qtyEditorState: QuantityEditor.State(qty: 1)))
            state.addProductState = nil
            return .none
        case .addProduct:
            return .none
        }
    }
}

struct CartEnvironment: DependencyKey {
    var getCart: () async throws -> [CartProduct.State]
    static var testValue: CartEnvironment {
        Self(getCart: unimplemented("getCart is unimplemented"))
    }
    
    static var liveValue: CartEnvironment {
        Self(getCart: {
            try await Task.sleep(for: .seconds(1))
            return (1...5).map {
                CartProduct.State(
                    id: UUID(),
                    name: "iPhone \($0)",
                    price: $0 * 5_000_000,
                    qtyEditorState: QuantityEditor.State(qty: $0, minQty: $0, maxQty: $0 + 3),
                    isChecked: Bool.random()
                )
            }
        })
    }
}

extension DependencyValues {
  var cartEnv: CartEnvironment {
    get { self[CartEnvironment.self] }
    set { self[CartEnvironment.self] = newValue }
  }
}

struct CartView: View {
    let store: StoreOf<Cart>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                ScrollView {
                    VStack {
                        ForEachStore(self.store.scope(state: \.items, action: Cart.Action.products), content: CartProductView.init)
                    }
                    .padding()
                }
                HStack {
                    Text("Total Price") + Text(String(viewStore.totalPrice))
                }
            }
            .sheet(store: store.scope(state: \.$addProductState, action: { .addProduct($0) }), content: AddProductView.init)
        }
        
        .navigationTitle("Cart")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.store.send(.didTapAddItem)
                } label: {
                    Text("+")
                        .font(.title)
                }
            }
        }
        .task {
            store.send(.didLoad)
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(store: Store(initialState: Cart.State()) { Cart() })
    }
}
