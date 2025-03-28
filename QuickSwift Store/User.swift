//
//  User.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 27/03/25.
//

import SwiftUI
import SwiftData

struct User: View {
    static let tag = "__tag_user__"
    
    @Binding var navPath: NavigationPath
    enum subViewType {
        case allOrders
    }
    
    let orderLimit = 3
    @Query(sort: \OrderModel.orderedAt, order: .reverse)
    private var orders: [OrderModel]
    
    private func orderLink(_ order: OrderModel) -> some View {
        NavigationLink(value: order) {
            HStack {
                VStack(alignment: .leading) {
                    Text(order.orderedAt.formatted(
                        date: .abbreviated,
                        time: .shortened
                    ))
                    .font(.caption)
                    Text("\(order.itemCount) items")
                }
                Spacer()
                Text(order.total)
            }
        }
    }
    
    var body: some View {
        NavigationStack(path: $navPath) {
            List {
                Section {
                    ForEach(
                        orders.prefix(orderLimit),
                        content: orderLink
                    )
                    if orders.count > orderLimit {
                        NavigationLink(value: subViewType.allOrders) {
                            Text("View All Orders ")
                            + Text("(\(orders.count) total)").foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("My Orders")
                }
            }
            .navigationTitle("My Page")
            .navigationDestination(for: OrderModel.self) { order in
                OrderDetails(order: order)
            }
            .navigationDestination(for: subViewType.self) { subview in
                switch subview {
                case .allOrders:
                    List {
                        ForEach(orders, content: orderLink)
                    }
                    .navigationTitle("All Orders")
                }
            }
        }
    }
}
    
#Preview {
    @Previewable @State var path = NavigationPath()
    let _ = OrderModel.samples.generate(amount: 5).forEach { order in
        previewContainer.mainContext.insert(order)
    }
    NavigationStack{
        User(navPath: $path)
            .modelContainer(previewContainer)
    }
}
