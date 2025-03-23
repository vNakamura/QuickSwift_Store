//
//  ItemAmountStepper.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 23/03/25.
//

import SwiftUI

struct ItemAmountStepper: View {
    @Binding var value: Int
    var prefix: String = ""
    var onZero: (() -> Void)?
    
    @State private var showingAlert = false
    func updateValue(by amount: Int) {
        var newValue = value + amount
        if newValue <= 0 {
            showingAlert = true
            newValue = 1
        }
        value = newValue
    }
    
    func button(_ adjustment: Int) -> some View {
        var icon = adjustment > 0 ? "plus" : "minus"
        var role: ButtonRole? = nil
        if value <= 1, adjustment < 0 {
            icon = "multiply"
            role = .destructive
        }
        return Button(role: role) {
            updateValue(by: adjustment)
        } label: {
            Image(systemName: icon)
                .frame(minWidth: 24, minHeight: 24)
        }
            .buttonStyle(.bordered)
            .clipShape(.circle)
    }
    
    var body: some View {
        HStack {
            Text(prefix)
                .fixedSize()
            button(-1)
            Text("\(value)")
                .monospaced()
                .fixedSize()
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .overlay {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(.ultraThinMaterial, lineWidth: 2)
                }
            button(1)
        }
        .alert("Remove from Cart?", isPresented: $showingAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Remove", role: .destructive) {
                onZero?()
            }
        }
    }
}

#Preview("Basic", traits: .sizeThatFitsLayout) {
    @Previewable @State var amount = 1
    ItemAmountStepper(value: $amount, prefix: "In Cart: ")
}
