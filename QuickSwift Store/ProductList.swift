//
//  ProductList.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 21/03/25.
//

import SwiftUI

struct ProductList: View {
    static let tag = "__tag_product_list__"
    
    @State private var products = [Product]()
    func loadProducts() async {
        products = await ProductService.getAllProducts()
    }
    
    var body: some View {
        NavigationStack {
            ScrollView{
                LazyVGrid(
                    columns: [
                        GridItem(.adaptive(minimum: 128), spacing: 10)
                    ], spacing: 15
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
}

#Preview {
    ProductList()
}
