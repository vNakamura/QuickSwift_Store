//
//  ContentView.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 16/03/25.
//

import SwiftUI

struct ContentView: View {
    func tab<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content?
    ) -> some View {
        NavigationStack {
            ScrollView {
                content()
            }
            .navigationTitle(title)
        }
    }
    
    var body: some View {
        TabView {
            Tab("Browse", systemImage: "storefront") {
                NavigationStack {
                    ScrollView{
                        LazyVGrid(
                            columns: [
                                GridItem(.adaptive(minimum: 110), spacing: 15)
                            ], spacing: 30
                        ) {
                            ForEach(1...30, id: \.self) {
                                ShopItem(price: "$9.99", name: "Item \($0)")
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    .navigationDestination(for: String.self) { name in
                        Text(name)
                    }
                    .navigationTitle("QuickSwift Store")
                }
            }
            Tab("Cart", systemImage: "cart") {
                Text("Cart")
            }
            Tab("User", systemImage: "person.fill") {
                Text("User")
            }
        }
    }
}

#Preview {
    ContentView()
}
