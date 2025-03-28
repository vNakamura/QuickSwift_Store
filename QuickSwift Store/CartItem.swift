//
//  CartItem.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 21/03/25.
//

import SwiftUI

struct CartItem: View {
    @Bindable var item: CartItemModel
    var readOnly: Bool = false
    var onZero: (() -> Void)?
    
    var body: some View {
        if let product = item.product {
            HStack(alignment: .top) {
                ProductImage(url: product.image)
                    .frame(height:80)
                VStack(alignment: .leading) {
                    Text(product.name)
                        .truncationMode(.tail)
                    Spacer(minLength: 0)
                    HStack{
                        Text(
                            product.formattedPrice
                        )
                        Spacer(minLength: 1)
                        ItemAmountStepper(
                            value: $item.amount
                        ) {
                            onZero?()
                        }
                    }
                }
            }
        } else {
            Text("Invalid product")
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let item = CartItemModel(product: .withImage, amount: 2)
    CartItem(item: item)
}
