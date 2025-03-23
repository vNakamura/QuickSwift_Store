//
//  ProductImage.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 20/03/25.
//

import SwiftUI
import NukeUI

struct ProductImage: View {
    var  url: String?
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.white
            Group {
                if let image = url {
                    LazyImage(url: URL(string: image)) { phase in
                        if let image = phase.image {
                            image.resizable()
                        } else if phase.error != nil {
                            NoImage()
                        } else {
                            ProgressView()
                        }
                    }
                } else {
                    NoImage()
                }
            }
                .cornerRadius(6)
                .padding(6)
                .scaledToFit()
        }
            .aspectRatio(1.0, contentMode: .fit)
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.ultraThinMaterial, lineWidth: 2)
            }
    }
}

#Preview {
    ProductImage(url: ProductModel.withImage.image)
}
