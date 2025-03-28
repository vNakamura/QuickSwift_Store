//
//  PreviewSampleData.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 23/03/25.
//

#if DEBUG

import Foundation
import SwiftUI
import SwiftData

extension ProductModel {
    static let withImage = ProductModel(
        id: 1,
        name: "With Image",
        price: 9.99,
        descriptionText: "A product to preview containing an image",
        category: "sample",
        image: "https://picsum.photos/200"
    )
    static let withoutImage = ProductModel(
        id: 2,
        name: "Without Image",
        price: 5.99,
        descriptionText: "A product to preview containing no image",
        category: "sample"
    )
}

extension CartItemModel {
    enum samples {
        static let with2products = [
            CartItemModel(product: .withImage, amount: 2),
            CartItemModel(product: .withoutImage, amount: 1),
        ]
    }
}

extension OrderModel {
    struct samples {
        static let single = generate().first!
        
        static func generate(amount: Int = 1) -> [OrderModel] {
            return (0..<amount).map { index in
                let orderedAt = Calendar.current.date(
                    byAdding: .day, value: -index, to: Date()
                ) ?? Date()
                return  OrderModel(
                    items: CartItemModel.samples.with2products,
                    deliveryAddress: "123 Main St.",
                    derliveryMethod: "Regular",
                    deliveryCost: "$4.99",
                    paymentType: "Credit Card",
                    paymentIdentifier: "**** 1234",
                    total: "$123.45",
                    orderedAt: orderedAt
                )
            }
        }
    }
}

@MainActor
let previewContainer: ModelContainer = {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Schema([
            CartItemModel.self,
            OrderModel.self,
        ]), configurations: config)
        
        return container
    } catch {
        fatalError("Failed to create container.")
    }
}()
#endif
