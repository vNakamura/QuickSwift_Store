//
//  ProductList.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 21/03/25.
//

import SwiftUI

struct ProductList: View {
    static let tag = "__tag_product_list__"
    @Binding var navPath: NavigationPath
    
    @State private var products = [ProductModel]()
    func loadProducts() async {
        products = await ProductService.getAllProducts()
    }
    
    var body: some View {
        NavigationStack(path: $navPath) {
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
            .navigationDestination(for: ProductModel.self) { product in
                ProductDetails(product: product)
            }
            .navigationTitle("QuickSwift Store")
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    ProductList(navPath: $path)
}
