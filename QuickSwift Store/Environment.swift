//
//  Environment.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 27/03/25.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var clearShopPath: () -> Void = {}
    @Entry var clearCartPath: () -> Void = {}
    @Entry var setUserNavPath: (User.subViewType?) -> Void = { _ in }
    @Entry var changeTab: (_ to: String) -> Void = { to in }
}
