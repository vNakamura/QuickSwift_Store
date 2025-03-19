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
    let image: String
    
    var body: some View {
        NavigationLink(value: name) {
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomTrailing){
                    AsyncImage(url: URL(string: image)) { phase in
                        if let image = phase.image {
                            image.resizable()
                        } else if phase.error != nil {
                            Color.red
                        } else {
                            Color.gray
                        }
                    }
                        .scaledToFit()
                        .cornerRadius(10)
                }
                Spacer(minLength: 10)
                Text(price)
                    .font(.headline)
                Text(name)
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

#Preview {
    ShopItem(price: "$9.99", name: "Item 1", image: "https://picsum.photos/200")
}
