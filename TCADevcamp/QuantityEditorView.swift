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
        var fact: String?
        
        var isMinusButtonDisabled: Bool {
            qty <= minQty
        }
        
        var isPlusButtonDisabled: Bool {
            guard let maxQty = maxQty else { return false }
            return qty >= maxQty
        }
    }
    
    enum Action: Equatable {
        case didTapMinus
        case didTapPlus
        case didTapCheckFact
        case receiveFact(String)
    }
    
    @Dependency(\.factCheckEnv) var env
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didTapMinus:
            state.fact = nil
            state.qty -= 1
            return .none
        case .didTapPlus:
            state.fact = nil
            state.qty += 1
            return .none
        case .didTapCheckFact:
            state.fact = nil
            let qty = state.qty
            return .run { send in
                try await send(.receiveFact(env.randomFactCheck(qty)))
            }
        case .receiveFact(let fact):
            state.fact = fact
            return .none
        }
    }
}

struct FactCheckEnvironment {
    var randomFactCheck: (Int) async throws -> String
}

extension FactCheckEnvironment: DependencyKey {
    
    static let testValue = Self(
        randomFactCheck: unimplemented("randomFactCheck is unimplemented")
    )
    static let liveValue = Self(
        randomFactCheck: { number in
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "http://numbersapi.com/\(number)")!)
            return String(decoding: data, as: UTF8.self)
        }
    )
}

extension DependencyValues {
    var factCheckEnv: FactCheckEnvironment {
        get { self[FactCheckEnvironment.self] }
        set { self[FactCheckEnvironment.self] = newValue }
    }
}

struct FactCheckView: View {
    let store: StoreOf<QuantityEditor>
    var body: some View {
        VStack {
            QuantityEditorView(store: store)
            Button("Check Fun Fact") {
                store.send(.didTapCheckFact)
            }
            WithViewStore(store, observe: { $0.fact }) { viewStore in
                if let text = viewStore.state {
                    Text(text)
                }
            }
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
