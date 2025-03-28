//
//  OrderDetails.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 28/03/25.
//

import SwiftUI

struct OrderDetails: View {
    var order: OrderModel
    @State var viewingProduct: ProductModel?
    
    func itemLabel(_ item: OrderItemModel) -> some View {
        Group {
            if let product = item.product {
                HStack(alignment: .top) {
                    ProductImage(url: product.image)
                        .frame(height:80)
                    VStack(alignment: .leading) {
                        Text(product.name)
                        HStack{
                            Text(
                                product.formattedPrice
                            )
                            Text("×\(item.amount)")
                            Spacer(minLength: 1)
                            Text(item.formattedItemTotal)
                                .bold()
                        }
                    }
                }
            } else {
                Text("Invalid Product")
            }
        }
        .contentShape(Rectangle())
    }
    
    var itemsSection: some View {
        Section {
            ForEach(order.items) { item in
                Button {
                    viewingProduct = item.product
                } label: {
                    itemLabel(item)
                }
                .listRowInsets(EdgeInsets(
                    top: 10,
                    leading: 10,
                    bottom: 10,
                    trailing: 10
                ))
                .buttonStyle(.plain)
            }
        } header: {
            Text("Products")
        }
    }
    
    var deliverySection: some View {
        Section {
            HStack {
                Text(order.derliveryMethod)
                Spacer()
                Text(order.deliveryCost).bold()
            }
            Text(order.deliveryAddress)
        } header: {
            Text("Delivery")
        }
    }
    
    var paymentSection: some View {
        Section {
            HStack {
                Text(order.paymentType)
                Spacer()
                Text(order.paymentIdentifier)
            }
        } header: {
            Text("Payment")
        }
    }
    
    var totalSection: some View {
        Section {
            HStack {
                Text("Total:")
                Spacer()
                Text(order.total)
            }
        }
        .font(.title2)
    }
    
    var body: some View {
        List {
            itemsSection
            deliverySection
            paymentSection
            totalSection
        }
        .navigationTitle(order.orderedAt.formatted(
            date: .abbreviated,
            time: .shortened
        ))
        .sheet(item: $viewingProduct) { product in
            ProductDetails(
                product: product,
                showRelated: false,
                readOnly: true
            ) {
                viewingProduct = nil
            }
                .presentationDetents([.fraction(0.8), .large])
        }
    }
}

#Preview {
    NavigationStack {
        OrderDetails(order: OrderModel.samples.single)
    }
}
