//
//  Product.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 20/03/25.
//

import Foundation

struct ProductModel: Codable, Identifiable, Hashable {
    static func format(price unitPrice: Double, times: Int = 1) -> String {
        let multipliedPrice = unitPrice * Double(times)
        return multipliedPrice.formatted(
            .currency(code: "USD")
            .locale(Locale(identifier: "en_US"))
        )
    }
    var id: Int
    var name: String
    var price: Double
    var formattedPrice: String {
        return ProductModel.format(price: price)
    }
    var descriptionText: String
    var category: String
    var image: String? = nil
    
    private enum CodingKeys: String, CodingKey {
        case id, price, category, image
        case name = "title"
        case descriptionText = "description"
    }
}

enum ProductService {
    static let apiURL = URL(string: "https://fakestoreapi.com/products")
    
    static func getAllProducts() async -> [ProductModel] {
        //TODO: show errors to user
        guard let url = apiURL else {
            print("Invalid path")
            return []
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decoded = try? JSONDecoder().decode(
                [ProductModel].self, from: data
            ) {
                return decoded.shuffled()
            }
        } catch {
            print("Could not load product list")
        }
        return []
    }
    
    static func getProducts(
        of category: String,
        ignoring current: ProductModel? = nil
    ) async -> [ProductModel] {
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
                [ProductModel].self, from: data
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
            print("Could not load related items")
        }
        return []
    }
}
