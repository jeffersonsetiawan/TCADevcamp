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
    }
    
    enum Action {
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        return .none
    }
}

struct CartProductView: View {
    let store: StoreOf<CartProduct>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                Toggle(isOn: .constant(false)) {
                    Text("Product Name")
                    Text(10_000.formatted(.currency(code: "idr")))
                }
            }
        }
    }
}

struct CartProductView_Previews: PreviewProvider {
    static var previews: some View {
        CartProductView(store: Store(initialState: CartProduct.State(
            id: UUID()
        )) { CartProduct() })
    }
}
