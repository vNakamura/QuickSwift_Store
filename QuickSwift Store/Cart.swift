//
//  Cart.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 21/03/25.
//

import SwiftData
import SwiftUI

struct Cart: View {
    static let tag = "__tag_cart__"
    
    @Query(sort: \CartItemModel.addedAt) private var items: [CartItemModel]
    var startShoppingAction: (() -> Void)?
    @Environment(\.modelContext) var modelContext
    
    private var subtotal: String {
        let raw = items.reduce(0.0) { acc, item in
            let itemPrice = item.product?.price ?? 0
            let itemTotal = itemPrice * Double(item.amount)
            return acc + itemTotal
        }
        return ProductModel.format(price: raw)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if items.isEmpty {
                    empty
                } else {
                    list
                }
            }
            .navigationTitle("Shopping Cart")
        }
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
    
    var list: some View {
        List {
            ForEach(items) { item in
                CartItem(item: item) {
                    modelContext.delete(item)
                }
                .listRowInsets(EdgeInsets(
                    top: 4,
                    leading: 0,
                    bottom: 2,
                    trailing: 2
                ))
            }
            .onDelete { offsets in
                for offset in offsets {
                    modelContext.delete(items[offset])
                }
            }
            Section("Subtotal") {
                Text(subtotal)
            }
        }
        .listRowSpacing(6)
    }
}

#Preview("Empty") {
    Cart()
}
#Preview("With Items") {
    let _ = [
        CartItemModel(product: .withImage, amount: 2),
        CartItemModel(product: .withoutImage, amount: 1),
    ].forEach { item in
        previewContainer.mainContext.insert(item)
    }
    Cart()
        .modelContainer(previewContainer)
}
