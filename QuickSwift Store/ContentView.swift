//
//  ContentView.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 16/03/25.
//

import SwiftUI

struct ContentView: View {
    //TODO: Convert to proper MVVM
    struct Product: Codable, Identifiable {
        static let api_path = "https://fakestoreapi.com/products"
        let id: Int
        let name: String
        let price: Double
        let description: String
        let category: String
        let image: String
        
        private enum CodingKeys: String, CodingKey {
            case id, price, description, category, image
            case name = "title"
        }
    }
    @State private var products = [Product]()
    func loadProducts() async {
        //TODO: show errors to user
        guard let url = URL(string: Product.api_path) else {
            print("Invalid path")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decoded = try? JSONDecoder().decode(
                [Product].self, from: data
            ) {
                products = decoded            
            }
        } catch {
            print("Could not load data")
        }
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
                                ShopItem(
                                    price: product.price.formatted(
                                        .currency(code: "USD")
                                    ),
                                    name: product.name,
                                    image: product.image
                                )
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    .task {
                        await loadProducts()
                    }
                    .navigationDestination(for: String.self) { name in
                        Text(name)
                    }
                    .navigationTitle("QuickSwift Store")
                }
            }
            Tab("Cart", systemImage: "cart") {
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
