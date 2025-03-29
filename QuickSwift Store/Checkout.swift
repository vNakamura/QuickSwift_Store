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
    @AppStorage("payment_card") private var paymentCard = "*** 4242"
    @State var showingAlert = false
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.clearShopPath) var clearShopPath
    @Environment(\.clearCartPath) var clearCartPath
    @Environment(\.setUserNavPath) var setUserNavPath
    @Environment(\.changeTab) var changeTab
    
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
    
    private func createOrder() -> Void {
        let order = OrderModel(
            items: items,
            deliveryAddress: address,
            derliveryMethod: deliveryOption.name,
            deliveryCost: ProductModel.format(price: deliveryOption.price),
            paymentType: "Credit Card",
            paymentIdentifier: paymentCard,
            total: total
        )
        showingAlert = true
        modelContext.insert(order)
    }
    
    private func clearCart() {
        items.forEach { cartItem in
            modelContext.delete(cartItem)
        }
        clearCartPath()
    }
    
    var body: some View {
        List {
            CheckoutItems(items: items)
            DeliverySection(
                address: $address,
                deliveryOption: $deliveryOption
            )
            PaymentSection(paymentCard: $paymentCard)
            SendOrderSection(
                total: total,
                blocked: blocked,
                onSendPress: createOrder
            )
        }
        .navigationTitle("Checkout")
        .alert("Order Sent", isPresented: $showingAlert) {
            Button("My Orders") {
                clearCart()
                changeTab(User.tag)
                setUserNavPath(User.subViewType.allOrders)
            }
            Button("OK") {
                clearCart()
                clearShopPath()
                changeTab(ProductList.tag)
            }
        }
    }
    
    private struct CheckoutItems: View {
        var items: [CartItemModel]
        
        var body: some View {
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
    }
    
    private struct DeliverySection: View {
        @Binding var address: String
        @Binding var deliveryOption: DeliveryOptionModel
        
        var body: some View {
            Section {
                NavigationLink {
                    AddressSearch(address: $address)
                } label: {
                    Label {
                        Text("Address: ").bold() + (
                            address.isEmpty
                            ? Text("Search")
                                .italic()
                                .foregroundStyle(.secondary)
                            : Text(address)
                        )
                    } icon: {
                        Image(systemName: "map")
                    }
                }
                if !address.isEmpty {
                    ForEach(DeliveryOptionModel.sample) { option in
                        DeliveryOption(
                            option: option,
                            selected: $deliveryOption
                        )
                    }
                }
            } header: {
                Text("Delivery")
            }
        }
    }
    
    private struct PaymentSection: View {
        @Binding var paymentCard: String
        
        var body: some View {
            Section {
                NavigationLink{
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
    }
    
    private struct SendOrderSection: View {
        var total: String
        var blocked: Bool
        var onSendPress: () -> Void
        
        var body: some View {
            Section {
                Text("Total: ").bold()
                + Text(total)
                    .foregroundStyle(blocked ? .secondary : .primary)
                    .italic(blocked)
                Button(action: onSendPress) {
                    HStack {
                        Spacer()
                        Text("Place Order")
                            .frame(minHeight: 32)
                        Spacer()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(blocked)
            }
        }
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
