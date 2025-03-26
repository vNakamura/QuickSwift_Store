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
    @State var shopNavPath = NavigationPath()
    @State var cartNavPath = NavigationPath()
    @Query private var cart: [CartItemModel]
    
    var body: some View {
        TabView(selection: $currentTab) {
            Tab(
                "Browse", systemImage: "storefront",
                value: ProductList.tag
            ) {
                ProductList(navPath: $shopNavPath)
            }
            Tab("Cart", systemImage: "cart.fill", value: Cart.tag) {
                Cart(navPath: $cartNavPath)
            }
            .badge(cart.reduce(0){ $0 + $1.amount })
            Tab("User", systemImage: "person.fill", value: "user") {
                Text("User")
            }
        }
        .environment(\.changeTab) { to in
            currentTab = to
        }
        .environment(\.clearShopPath) {
            shopNavPath = NavigationPath()
        }
        .environment(\.clearCartPath) {
            cartNavPath = NavigationPath()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
