//
//  Cart.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 21/03/25.
//

import SwiftUI

struct Cart: View {
    static let tag = "__tag_cart__"
    var startShoppingAction: (() -> Void)?
    
    var body: some View {
        Group {
            empty
        }
        .navigationTitle("Shopping Cart")
    }
    
    var empty: some View {
        ContentUnavailableView {
            Label("Your cart is empty :(", systemImage: "cart")
        } description: {
            Text("Looks like you haven't added anything to your cart yet.")
        } actions: {
            Button("Start shopping") {
                startShoppingAction?()
            }
        }
    }
}

#Preview {
    Cart()
}
