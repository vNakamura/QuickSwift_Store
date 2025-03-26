//
//  CartModel.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 21/03/25.
//

import Foundation
import SwiftData

@Model
class CartItemModel {
    static func sum(of items: [CartItemModel]) -> String {
        let raw = items.reduce(0.0) { acc, item in
            let itemPrice = item.product?.price ?? 0
            let itemTotal = itemPrice * Double(item.amount)
            return acc + itemTotal
        }
        return ProductModel.format(price: raw)
    }
    
    @Attribute(.unique) var id: Int
    var amount: Int
    var addedAt: Date
    
    // Store serialized product data to avoid SwiftData conflicts
    // with reserved property names. The original data from
    // fakestoreapi.com uses `description` which is a reserved
    // name in Swift and causes errors.
    private var productData: Data
    
    init(product: ProductModel, amount: Int = 1) {
        self.id = product.id
        if let data = try? JSONEncoder().encode(product) {
            self.productData = data
        } else {
            self.productData = Data()
        }
        self.amount = amount
        self.addedAt = Date()
    }
    
    var product: ProductModel? {
        try? JSONDecoder().decode(ProductModel.self, from: productData)
    }
}
