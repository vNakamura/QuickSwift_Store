//
//  OrderModel.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 27/03/25.
//

import Foundation
import SwiftData

@Model
class OrderModel {
    var id: UUID
    @Relationship(deleteRule: .cascade) var items: [OrderItemModel]
    var deliveryAddress: String
    var derliveryMethod: String
    var deliveryCost: String
    var paymentType: String
    var paymentIdentifier: String
    var total: String
    var orderedAt: Date
    
    var itemCount: Int {
        items.reduce(0) { $0 + $1.amount }
    }
    
    init(
        items: [CartItemModel],
        deliveryAddress: String,
        derliveryMethod: String,
        deliveryCost: String,
        paymentType: String,
        paymentIdentifier: String,
        total: String,
        orderedAt: Date = Date()
    ) {
        self.id = UUID()
        self.items = items.map { cartItem in
            return OrderItemModel(from: cartItem)
        }
        self.deliveryAddress = deliveryAddress
        self.derliveryMethod = derliveryMethod
        self.deliveryCost = deliveryCost
        self.paymentType = paymentType
        self.paymentIdentifier = paymentIdentifier
        self.total = total
        self.orderedAt = orderedAt
    }
}

@Model
class OrderItemModel {
    @Attribute(.unique) var id: UUID
    var amount: Int
    var itemTotal: Double
    var formattedItemTotal: String
    
    var productData: Data
    var product: ProductModel? {
        try? JSONDecoder().decode(ProductModel.self, from: productData)
    }
    
    init(from cartItem: CartItemModel) {
        id = UUID()
        amount = cartItem.amount
        productData = cartItem.productData
        let itemPrice = cartItem.product?.price ?? 0
        itemTotal = itemPrice * Double(cartItem.amount)
        formattedItemTotal = ProductModel.format(
            price: itemPrice,
            times: cartItem.amount
        )
    }
}

