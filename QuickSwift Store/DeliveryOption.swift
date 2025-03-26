//
//  DeliveryOption.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 26/03/25.
//

import SwiftUI

struct DeliveryOptionModel: Equatable, Identifiable {
    let id: Int
    let name: String
    let days: Int
    let price: Double
    
    static let sample: [DeliveryOptionModel] = [
        DeliveryOptionModel(id: 1, name: "Regular", days: 3, price: 4.99),
        DeliveryOptionModel(id: 2, name: "Expedited", days: 1, price: 12.99),
    ]
}

struct DeliveryOption: View {
    var option: DeliveryOptionModel
    @Binding var selected: DeliveryOptionModel
    
    private var icon: String {
        return option == selected ? "circle.circle.fill" : "circle"
    }
    private var deliveryDate: String {
        switch option.days {
        case 1:
            return "Tomorrow"
        default:
            return Date(timeIntervalSinceNow:
                86400 * Double(option.days)
            )
                .formatted(
                    .dateTime
                        .weekday()
                        .day()
                        .month(.abbreviated)
                )
        }
    }
    
    var body: some View {
        Button {
            selected = option
        } label: {
            Label{
                VStack(alignment: .leading) {
                    HStack {
                        Text(option.name)
                        Spacer()
                        Text(ProductModel.format(price: option.price))
                            .bold()
                    }
                    Text("Receive: ").font(.callout)
                    + Text(deliveryDate).bold()
                }
            } icon: {
                Image(systemName: icon)
                    .foregroundStyle(Color.accentColor)
            }
                .contentShape(Rectangle()) // Ensure blank spaces can be tapped
        }
            .buttonStyle(.plain)
    }
}

#Preview("Selected") {
    DeliveryOption(
        option: DeliveryOptionModel.sample[1],
        selected: .constant(DeliveryOptionModel.sample[1]))
}
#Preview("Unselected") {
    DeliveryOption(
        option: DeliveryOptionModel.sample[0],
        selected: .constant(DeliveryOptionModel.sample[1]))
}
