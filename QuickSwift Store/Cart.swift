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
    @State private var viewingProduct: ProductModel? = nil
    @Environment(\.modelContext) var modelContext
    
    private var subtotal: String {
        return CartItemModel.sum(of: items)
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
            .sheet(item: $viewingProduct) { product in
                ProductDetails(product: product, showRelated: false) {
                    viewingProduct = nil
                }
                    .presentationDetents([.fraction(0.8), .large])
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
        NavigationStack {
            List {
                ForEach(items) { item in
                    Button {
                        viewingProduct = item.product
                    } label: {
                        CartItem(item: item) {
                            modelContext.delete(item)
                        }
                    }
                    .listRowInsets(EdgeInsets(
                        top: 12,
                        leading: 8,
                        bottom: 8,
                        trailing: 8
                    ))
                    .buttonStyle(.plain)
                }
                .onDelete { offsets in
                    for offset in offsets {
                        modelContext.delete(items[offset])
                    }
                }
                Section("Subtotal") {
                    Text(subtotal)
                }
                NavigationLink {
                    Checkout()
                } label: {
                    Label("Checkout", systemImage: "shippingbox")
                }
            }
            .listRowSpacing(6)
        }
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
