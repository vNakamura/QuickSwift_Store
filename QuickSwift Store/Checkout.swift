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
    @AppStorage("delivery_address") private var address = ""
    @State private var deliveryOption: DeliveryOptionModel = .sample[0]
    @AppStorage("payment_card") private var paymentCard = ""
    
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
                Label {
                    Text("Address: ").bold() + (
                        address.isEmpty
                        ? Text("Search").italic().foregroundStyle(.secondary)
                        : Text(address)
                    )
                } icon: {
                    Image(systemName: "map")
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
    
    var payment: some View {
        Section {
            NavigationLink {
                CardForm(input: $paymentCard)
            } label: {
                Label {
                    Text("Credit Card: ").bold() + (
                        paymentCard.isEmpty
                        ? Text("Insert details")
                            .italic().foregroundStyle(.secondary)
                        : Text(paymentCard)
                    )
                } icon: {
                    Image(systemName: "creditcard")
                }
            }
        } header: {
            Text("Payment")
        }
    }
    
    var total: String {
        if address.isEmpty {
            return "Awaiting delivery info"
        }
        let costs: [CartItemModel] = [
            CartItemModel(
                product: ProductModel(
                    id: -1,
                    name: "Shipping",
                    price: deliveryOption.price,
                    descriptionText: deliveryOption.name,
                    category: "extra"
                )
            )
        ]
        return CartItemModel.sum(of: costs + items)
    }
    var blocked: Bool {
        return address.isEmpty || paymentCard.isEmpty
    }
    var complete: some View {
        Section {
            Text("Total: ").bold()
            + Text(total)
                .foregroundStyle(blocked ? .secondary : .primary)
                .italic(blocked)
            Button {
                
            } label: {
                Text("Place Order")
                    .frame(minHeight: 32)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(blocked)
        }
    }
    
    var body: some View {
        List {
            products
            delivery
            payment
            complete
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
