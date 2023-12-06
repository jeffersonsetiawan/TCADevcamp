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
        
    }
    
    enum Action {
        case didLoad
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didLoad:
            return .none
        }
    }
}

struct CartView: View {
    let store: StoreOf<Cart>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                ScrollView {
                    VStack {
                        Text("Cart Product Here")
                    }
                    .padding()
                }
                HStack {
                    Text("Total Price")
                }
            }
        }
        
        .navigationTitle("Cart")
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
