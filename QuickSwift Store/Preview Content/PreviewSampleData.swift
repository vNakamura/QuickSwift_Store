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

@MainActor
let previewContainer: ModelContainer = {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CartItemModel.self, configurations: config)
        
        return container
    } catch {
        fatalError("Failed to create container.")
    }
}()
#endif
