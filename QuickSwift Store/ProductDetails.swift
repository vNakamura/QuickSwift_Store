//
//  ProductDetails.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 20/03/25.
//

import SwiftUI

struct ProductDetails: View {
    var product: Product
    @State var relatedProducts = [Product]()
    
    func loadRelated() async {
        relatedProducts = await ProductService.getProducts(
            of: product.category,
            ignoring: product
        )
    }
    
    var body: some View {
        ScrollView{
            VStack {
                VStack(alignment: .leading) {
                    Text(product.category)
                        .font(.subheadline)
                    ProductImage(url: product.image)
                    HStack {
                        Text(product.formattedPrice)
                        Spacer()
                        Button(action: addToCart) {
                            Label("Add to Cart", systemImage: "cart.fill")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .font(.title2)
                    Text(product.description)
                    
                }
                .padding()
                Spacer(minLength: 20)
                Text("Related items")
                    .font(.title)
                ScrollView(.horizontal){
                    HStack(spacing: 20) {
                        ForEach(relatedProducts) { related in
                            ShopItem(product: related)
                                .frame(idealWidth: 140)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .task {
                    if relatedProducts.isEmpty {
                        await loadRelated()
                    }
                }
            }
        }
        .navigationTitle(product.name)
    }
    
    func addToCart() {
        //TODO: Add to cart
        print("Add product to cart: \(product.name)")
    }
}

#Preview {
    NavigationStack {
        ProductDetails(product: Product.withImage)
    }
}
