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
    return .none
  }
}

struct AddProductView: View {
  let store: StoreOf<AddProduct>
  var body: some View {
    Text("AddProduct")
  }
}

struct AddProductView_Previews: PreviewProvider {
  static var previews: some View {
    AddProductView(store: Store(initialState: AddProduct.State(id: UUID())) { AddProduct() })
  }
}
