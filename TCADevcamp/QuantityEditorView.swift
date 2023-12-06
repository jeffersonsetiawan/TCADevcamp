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
        internal init(qty: Int = 0, minQty: Int = 0, maxQty: Int? = nil, errorMessage: String? = nil) {
            self.qtyString = String(qty)
            self.qty = qty
            self.minQty = minQty
            self.maxQty = maxQty
            self.errorMessage = errorMessage
        }
        
        var qtyString = "0"
        var qty = 0
        var minQty = 0
        var maxQty: Int? = nil
        var errorMessage: String? = nil
        
        var isMinusButtonDisabled: Bool {
            qty <= minQty
        }
        
        var isPlusButtonDisabled: Bool {
            guard let maxQty = maxQty else { return false }
            return qty >= maxQty
        }
        
        func validate(newQty: Int) -> String? {
            if newQty < minQty {
                return "Below min quantity"
            }
            if let maxQty = maxQty, newQty > maxQty {
                return "Exceed max quantity"
            }
            return nil
        }
    }
    
    enum Action: Equatable {
        case didTapMinus
        case didTapPlus
        case didChangeText(String)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didTapMinus:
            let newQty = (Int(state.qtyString) ?? state.qty) - 1
            if let error = state.validate(newQty: newQty) {
                state.errorMessage = error
            } else {
                state.qtyString = String(newQty)
                state.qty = newQty
                state.errorMessage = nil
            }
            
            return .none
        case .didTapPlus:
            let newQty = (Int(state.qtyString) ?? state.qty) + 1
            if let error = state.validate(newQty: newQty) {
                state.errorMessage = error
            } else {
                state.qtyString = String(newQty)
                state.qty = newQty
                state.errorMessage = nil
            }
            
            return .none
        case .didChangeText(let string):
            state.qtyString = string
            guard let num = Int(string) else {
                state.errorMessage = "Quantity should be a number"
                return .none
            }
            if let error = state.validate(newQty: num) {
                state.errorMessage = error
            } else {
                state.qty = num
                state.errorMessage = nil
            }
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
                    .disabled(viewStore.isMinusButtonDisabled)
                    TextField("Qty", text: viewStore.binding(
                        get: \.qtyString,
                        send: { .didChangeText($0) }
                    ))
                    .frame(width: 50)
                    .keyboardType(.numberPad)
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
                if let errorMessage = viewStore.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(Color.red)
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
