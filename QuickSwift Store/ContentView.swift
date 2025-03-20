//
//  ContentView.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 16/03/25.
//

import SwiftUI

struct ContentView: View {
    @State var currentTab = ProductList.tag
    
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
            Tab("User", systemImage: "person.fill", value: "user") {
                Text("User")
            }
        }
    }
}

#Preview {
    ContentView()
}
