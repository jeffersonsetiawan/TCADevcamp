//
//  CartProductView.swift
//  TCADevcamp
//
//  Created by jefferson.setiawan on 04/12/23.
//

import ComposableArchitecture
import SwiftUI

struct CartProduct: Reducer {
    struct State: Equatable, Identifiable {
        var id: UUID
        var name: String
        var price: Int
        var qtyEditorState: QuantityEditor.State
        var isChecked = true
    }
    
    enum Action: Equatable {
        case didTapToggle(Bool)
        case qtyEditor(QuantityEditor.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.qtyEditorState, action: /Action.qtyEditor) {
            QuantityEditor()
        }
        Reduce(self.core)
    }
    
    private func core(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didTapToggle(let bool):
            state.isChecked = bool
            return .none
        case .qtyEditor:
            return .none
        }
    }
}

struct CartProductView: View {
    let store: StoreOf<CartProduct>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                Toggle(isOn: viewStore.binding(get: \.isChecked, send: { .didTapToggle($0) })) {
                    Text(viewStore.name)
                    Text(viewStore.price.formatted(.currency(code: "idr")))
                }
                
                QuantityEditorView(store: store.scope(state: \.qtyEditorState, action: CartProduct.Action.qtyEditor))
            }
        }
    }
}

struct CartProductView_Previews: PreviewProvider {
    static var previews: some View {
        CartProductView(store: Store(initialState: CartProduct.State(
            id: UUID(),
            name: "iPhone 15 Pro",
            price: 14_000_000,
            qtyEditorState: QuantityEditor.State())) { CartProduct() })
    }
}
