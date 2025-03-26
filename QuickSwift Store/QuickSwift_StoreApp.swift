//
//  QuickSwift_StoreApp.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 16/03/25.
//

import SwiftUI

@main
struct QuickSwift_StoreApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            CartItemModel.self,
            OrderModel.self
        ])
    }
}
