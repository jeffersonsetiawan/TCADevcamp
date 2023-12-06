//
//  AddProductView.swift
//  TCADevcamp
//
//  Created by jefferson.setiawan on 06/12/23.
//

import ComposableArchitecture
import SwiftUI

struct AddProduct: Reducer {
    struct State: Equatable {
        var id: UUID
        var name = ""
        var price = 0
    }
    
    enum Action: Equatable {
        case didChangeName(String)
        case didChangePrice(String)
        case didTapSubmit
        case addItemEffect(State)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didChangeName(let name):
            state.name = name
            return .none
        case .didChangePrice(let priceStr):
            guard let price = Int(priceStr) else {
                return .none
            }
            state.price = price
            return .none
        case .didTapSubmit:
            guard !state.name.isEmpty && state.price != 0 else { return .none }
            return .send(.addItemEffect(state))
        case .addItemEffect:
            return .none
        }
    }
}

struct AddProductView: View {
    let store: StoreOf<AddProduct>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                TextField("Name", text: viewStore.binding(get: \.name, send: { .didChangeName($0) }))
                TextField("Price", text: viewStore.binding(get: { String($0.price) }, send: { .didChangePrice($0) }))
                Button("Add") {
                    store.send(.didTapSubmit)
                }
            }
        }
    }
}

struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView(store: Store(initialState: AddProduct.State(id: UUID())) { AddProduct() })
    }
}
