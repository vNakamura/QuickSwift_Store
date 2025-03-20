//
//  Product.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 20/03/25.
//

import Foundation

struct Product: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let price: Double
    var formattedPrice: String {
        return price.formatted(
            .currency(code: "USD")
            .locale(Locale(identifier: "en_US"))
        )
    }
    let description: String
    let category: String
    var image: String? = nil
    
    private enum CodingKeys: String, CodingKey {
        case id, price, description, category, image
        case name = "title"
    }
}

enum ProductService {
    static let apiURL = URL(string: "https://fakestoreapi.com/products")
    
    static func getAllProducts() async -> [Product] {
        //TODO: show errors to user
        guard let url = apiURL else {
            print("Invalid path")
            return []
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decoded = try? JSONDecoder().decode(
                [Product].self, from: data
            ) {
                return decoded.shuffled()
            }
        } catch {
            print("Could not load data")
        }
        return []
    }
    
    static func getProducts(
        of category: String,
        ignoring current: Product? = nil
    ) async -> [Product] {
        guard let url = apiURL?
            .appending(path: "category")
            .appending(path: category)
        else {
            print("Invalid path")
            return []
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decoded = try? JSONDecoder().decode(
                [Product].self, from: data
            ) {
                if current == nil {
                    return decoded.shuffled()
                } else {
                    return decoded.filter { product in
                        product != current
                    }.shuffled()
                }
            }
        } catch {
            print("Could not load data")
        }
        return []
    }
}

#if DEBUG
extension Product {
    static let withImage = Product(
        id: 1,
        name: "With Image",
        price: 9.99,
        description: "A product to preview containing an image",
        category: "sample",
        image: "https://picsum.photos/200"
    )
    static let withoutImage = Product(
        id: 2,
        name: "Without Image",
        price: 5.99,
        description: "A product to preview containing no image",
        category: "sample"
    )
}
#endif
