//
//  ContentView.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 16/03/25.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State var currentTab = ProductList.tag
    @Query private var cart: [CartItemModel]
    
    var body: some View {
        TabView(selection: $currentTab) {
            Tab("Browse", systemImage: "storefront", value: ProductList.tag) {
                ProductList()
            }
            Tab("Cart", systemImage: "cart.fill", value: Cart.tag) {
                Cart(startShoppingAction: {
                    currentTab = ProductList.tag
                })
            }
            .badge(cart.reduce(0){ $0 + $1.amount })
            Tab("User", systemImage: "person.fill", value: "user") {
                Text("User")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
