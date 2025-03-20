//
//  ShopItem.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 17/03/25.
//

import SwiftUI

struct NoImage: View {
    var body: some View {
        Image(systemName: "photo")
            .font(.title)
            .foregroundStyle(.secondary)
    }
}

struct ShopItem: View {
    let product: Product
    
    var body: some View {
        NavigationLink(value: product) {
            VStack(alignment: .leading) {
                ProductImage(url: product.image)
                Spacer(minLength: 10)
                Text(product.formattedPrice)
                    .font(.headline)
                Text(product.name)
                    .font(.caption)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(8)
            .background {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .cornerRadius(14)
                    .shadow(
                        color: .secondary.opacity(0.3),
                        radius: 4,
                        y: 2
                    )
            }
        }
    }
}

#Preview("With Image", traits: .fixedLayout(width: 200, height: 250)) {
    ShopItem(product: Product.withImage)
}
#Preview("Without Image", traits: .fixedLayout(width: 200, height: 250)) {
    ShopItem(product: Product.withoutImage)
}
