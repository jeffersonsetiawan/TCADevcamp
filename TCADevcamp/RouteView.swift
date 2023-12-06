//
//  RouteView.swift
//  TCADevcamp
//
//  Created by jefferson.setiawan on 06/12/23.
//

import ComposableArchitecture
import SwiftUI

struct RouteView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink("1. Quantity Editor") {
                        QuantityEditorView(store: Store(initialState: QuantityEditor.State(qty: 0)) {
                            QuantityEditor()
                        })
                    }
                    
                    NavigationLink("2. Product Item") {
                        CartProductView(store: Store(initialState: CartProduct.State(id: UUID(), name: "iPhone 15", price: 10_000, qtyEditorState: QuantityEditor.State())) {
                            CartProduct()
                        })
                    }
                    
                    NavigationLink("3. Cart Page") {
                        CartView(store: Store(initialState: Cart.State()) {
                            Cart()
                        })
                    }
                }
            }
        }
    }
}
struct RouteView_Previews: PreviewProvider {
    static var previews: some View {
        RouteView()
    }
}
