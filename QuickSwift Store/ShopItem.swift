//
//  ShopItem.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 17/03/25.
//

import SwiftUI

struct ShopItem: View {
    let price: String
    let name: String
    
    var body: some View {
        NavigationLink(value: name) {
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomTrailing){
                    Rectangle()
                        .fill(.mint.gradient)
                        .aspectRatio(1, contentMode: .fill)
                        .cornerRadius(10)
                }
                Spacer(minLength: 10)
                Text(price).font(.headline)
                Text(name).font(.caption)
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

#Preview {
    ShopItem(price: "$9.99", name: "Item 1")
}
