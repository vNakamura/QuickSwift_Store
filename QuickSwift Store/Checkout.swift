//
//  Checkout.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 24/03/25.
//

import SwiftUI
import SwiftData

struct Checkout: View {
    @Query private var items: [CartItemModel]
    @State private var address = ""
    @State private var deliveryOption: DeliveryOptionModel = .sample[0]
    
    var products: some View {
        Section {
            ForEach(items) { item in
                if let product = item.product {
                    VStack(alignment: .leading){
                        Text(product.name)
                            .truncationMode(.tail)
                        HStack{
                            Text(product.formattedPrice)
                            + Text(" ⨉ \(item.amount)")
                                .fontWeight(.bold)
                            Spacer()
                            Text(ProductModel.format(
                                price: product.price,
                                times: item.amount
                            )).bold()
                        }
                    }
                }
            }
        } header: {
            Text("Products")
        } footer: {
            HStack{
                Spacer()
                Text("Subtotal: \(CartItemModel.sum(of: items))")
                    .font(.headline)
            }
        }
    }
    
    var delivery: some View {
        Section {
            NavigationLink {
                AddressSearch(address: $address)
            } label: {
                VStack {
                    Text("Address: ").bold() + (
                        address.isEmpty
                        ? Text("Search").italic().foregroundStyle(.secondary)
                        : Text(address)
                    )
                }
            }
            if !address.isEmpty {
                ForEach(DeliveryOptionModel.sample) { option in
                    DeliveryOption(option: option, selected: $deliveryOption)
                }
            }
        } header: {
            Text("Delivery")
        }
    }
    
    
    var body: some View {
        List {
            products
            delivery
        }
        .navigationTitle("Checkout")
    }
}

#Preview {
    let _ = [
        CartItemModel(product: .withImage, amount: 2),
        CartItemModel(product: .withoutImage, amount: 1),
    ].forEach { item in
        previewContainer.mainContext.insert(item)
    }
    NavigationStack{
        Checkout()
    }
        .modelContainer(previewContainer)
}
