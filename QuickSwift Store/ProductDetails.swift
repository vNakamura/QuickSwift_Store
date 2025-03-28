//
//  ProductDetails.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 20/03/25.
//

import SwiftUI
import SwiftData

struct ProductDetails: View {
    var product: ProductModel
    var showRelated: Bool
    var readOnly: Bool
    var onRemove: (() -> Void)?
    
    @State private var relatedProducts = [ProductModel]()
    @Environment(\.modelContext) private var modelContext
    @Query private var cartItems: [CartItemModel]
    
    init(
        product: ProductModel,
        showRelated: Bool = true,
        readOnly: Bool = false,
        onRemove: (() -> Void)? = nil
    ) {
        self.product = product
        self.showRelated = showRelated
        self.readOnly = readOnly
        self.onRemove = onRemove
        _cartItems = Query(
            filter: #Predicate { $0.id == product.id }
        )
    }
    
    func loadRelated() async {
        relatedProducts = await ProductService.getProducts(
            of: product.category,
            ignoring: product
        )
    }
    
    func addToCart() {
        if let existingItem = cartItems.first {
            existingItem.amount += 1
        } else {
            let newItem = CartItemModel(product: product)
            modelContext.insert(newItem)
        }
    }
    
    var body: some View {
        ScrollView{
            VStack {
                VStack(alignment: .leading) {
                    Text(product.category)
                        .font(.subheadline)
                    ProductImage(url: product.image)
                    Text(product.name)
                        .font(.title2)
                    HStack {
                        Text(product.formattedPrice)
                        Spacer()
                        if readOnly {
                            EmptyView()
                        } else if let item = cartItems.first {
                            let amountBinding = Binding(
                                get: { item.amount },
                                set: { newValue in
                                    item.amount = newValue
                                }
                            )
                            ItemAmountStepper(
                                value: amountBinding,
                                prefix: "In Cart:"
                            ) {
                                modelContext.delete(item)
                                onRemove?()
                            }
                        } else {
                            Button(action: addToCart) {
                                Label("Add to Cart", systemImage: "cart.fill")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .font(.title3)
                    Text(product.descriptionText)
                    
                }
                .padding()
                if showRelated {
                Text("Related items")
                    .font(.title2)
                    .padding(.top, 10)
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
        }
    }
}

#Preview("Normal") {
    NavigationStack {
        ProductDetails(product: ProductModel.withImage)
    }
    .modelContainer(previewContainer)
}
#Preview("No related items") {
    NavigationStack {
        ProductDetails(product: ProductModel.withImage, showRelated: false)
    }
    .modelContainer(previewContainer)
}
#Preview("Read only (Order history)") {
    NavigationStack {
        ProductDetails(
            product: ProductModel.withImage,
            showRelated: false,
            readOnly: true
        )
    }
    .modelContainer(previewContainer)
}
