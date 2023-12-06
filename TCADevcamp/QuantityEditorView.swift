//
//  QuantityEditorView.swift
//  TCADevcamp
//
//  Created by jefferson.setiawan on 04/12/23.
//

import ComposableArchitecture
import SwiftUI

struct QuantityEditor: Reducer {
    struct State: Equatable {
        var qty = 0
        var minQty = 0
        var maxQty: Int? = nil
        
        var isMinusButtonDisabled: Bool {
            qty <= minQty
        }
        
        var isPlusButtonDisabled: Bool {
            guard let maxQty = maxQty else { return false }
            return qty >= maxQty
        }
        
        init(qty: Int = 0, minQty: Int = 0, maxQty: Int? = nil) {
            self.qty = qty
            self.minQty = minQty
            self.maxQty = maxQty
        }
    }
    
    enum Action: Equatable {
        case didTapMinus
        case didTapPlus
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didTapMinus:
            state.qty -= 1
            return .none
        case .didTapPlus:
            state.qty += 1
            return .none
        }
    }
}

struct QuantityEditorView: View {
    let store: StoreOf<QuantityEditor>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    Button {
                        store.send(.didTapMinus)
                    } label: {
                        Text("-")
                            .padding()
                            .background(viewStore.isMinusButtonDisabled ? Color.gray : Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Text(String(viewStore.qty))
                    .frame(width: 50)
                    Button {
                        store.send(.didTapPlus)
                    } label: {
                        Text("+")
                            .padding()
                            .background(viewStore.isPlusButtonDisabled ? Color.gray : Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .disabled(viewStore.isPlusButtonDisabled)
                }
            }
        }
    }
}

struct QuantitiyEditorView_Previews: PreviewProvider {
    static var previews: some View {
        QuantityEditorView(store: Store(initialState: QuantityEditor.State()) {
            QuantityEditor()
        })
    }
}
