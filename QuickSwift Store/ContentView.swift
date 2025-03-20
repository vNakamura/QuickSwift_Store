//
//  ContentView.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 16/03/25.
//

import SwiftUI

struct ContentView: View {
    @State private var products = [Product]()
    func loadProducts() async {
        products = await ProductService.getAllProducts()
    }
    
    func tab<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content?
    ) -> some View {
        NavigationStack {
            ScrollView {
                content()
            }
            .navigationTitle(title)
        }
    }
    
    var body: some View {
        TabView {
            Tab("Browse", systemImage: "storefront") {
                NavigationStack {
                    ScrollView{
                        LazyVGrid(
                            columns: [
                                GridItem(.adaptive(minimum: 128), spacing: 15)
                            ], spacing: 30
                        ) {
                            ForEach(products) { product in
                                ShopItem(product: product)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    .task {
                        if products.isEmpty {
                            await loadProducts()                            
                        }
                    }
                    .navigationDestination(for: Product.self) { product in
                        ProductDetails(product: product)
                    }
                    .navigationTitle("QuickSwift Store")
                }
            }
            Tab("Cart", systemImage: "cart.fill") {
                Text("Cart")
            }
            Tab("User", systemImage: "person.fill") {
                Text("User")
            }
        }
    }
}

#Preview {
    ContentView()
}
