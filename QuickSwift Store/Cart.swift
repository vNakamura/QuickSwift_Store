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
    @Binding var navPath: NavigationPath
    
    @Query(sort: \CartItemModel.addedAt) private var items: [CartItemModel]
    @State private var viewingProduct: ProductModel? = nil
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.clearShopPath) var clearShopPath
    @Environment(\.changeTab) var changeTab
    
    private var subtotal: String {
        return CartItemModel.sum(of: items)
    }
    
    var body: some View {
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
    }
    
    var empty: some View {
        ContentUnavailableView {
            Label("Your cart is empty :(", systemImage: "cart")
        } description: {
            Text("Looks like you haven't added anything to your cart yet.")
        } actions: {
            Button("Start shopping") {
                changeTab(ProductList.tag)
            }
        }
    }
    
    var list: some View {
        NavigationStack(path: $navPath) {
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
            .navigationTitle("Shopping Cart")
        }
    }
}

#Preview("With Items") {
    @Previewable @State var path = NavigationPath()
    let _ = [
        CartItemModel(product: .withImage, amount: 2),
        CartItemModel(product: .withoutImage, amount: 1),
    ].forEach { item in
        previewContainer.mainContext.insert(item)
    }
    Cart(navPath: $path)
        .modelContainer(previewContainer)
}
#Preview("Empty") {
    Cart(navPath: .constant(NavigationPath()))
}
