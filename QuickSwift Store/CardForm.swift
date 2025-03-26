//
//  CardForm.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 26/03/25.
//

import SwiftUI

struct CardForm: View {
    @Binding var input: String
    
    @AppStorage("cardNumber") private var cardNumber = "4242424242424242"
    @AppStorage("cardholderName") private var cardholderName = "John Appleseed"
    @AppStorage("expiryDate") private var expiryDate = "12/34"
    @AppStorage("cvv") private var cvv = "123"
    
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?
    
    enum Field {
        case cardNumber, cardholderName, expiryDate, cvv
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Card Number", text: $cardNumber)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .cardNumber)
                    .onChange(of: cardNumber) { _oldValue, newValue in
                        cardNumber = String(newValue.prefix(19).filter { $0.isNumber })
                    }
                
                TextField("Cardholder Name", text: $cardholderName)
                    .keyboardType(.namePhonePad)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = nextField(after: .cardholderName)
                    }
                    .focused($focusedField, equals: .cardholderName)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.words)
                    .onChange(of: cardholderName) { _oldValue, newValue in
                        cardholderName = String(newValue.prefix(50).filter { $0.isLetter || $0.isWhitespace })
                    }
                
                TextField("MM/YY", text: $expiryDate)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .expiryDate)
                    .onChange(of: expiryDate) { _oldValue, newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        
                        if filtered.count > 2 && !newValue.contains("/") {
                            let month = filtered.prefix(2)
                            let rest = filtered.dropFirst(2).prefix(2)
                            expiryDate = "\(month)/\(rest)"
                        } else if filtered.count == 2 {
                            expiryDate = "\(filtered)/"
                        } else {
                            expiryDate = String(filtered.prefix(5))
                        }
                    }
                
                TextField("CVV", text: $cvv)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .cvv)
                    .onChange(of: cvv) { _oldValue, newValue in
                        cvv = String(newValue.prefix(4).filter { $0.isNumber })
                    }
            } header: {
                CreditCardView(
                    cardNumber: cardNumber,
                    cardholderName: cardholderName,
                    expiryDate: expiryDate,
                    cvv: cvv,
                    flipped: focusedField == .cvv
                )
                .padding(.top, 8)
                .padding([.bottom, .horizontal])
                .clipped()
            }
        }
        .navigationTitle("Add Credit Card")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .destructive) {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let lastDigits = String(
                        cardNumber.replacingOccurrences(
                            of: " ", with: ""
                        ).suffix(4)
                    )
                    input = "**** \(lastDigits)"
                    dismiss()
                }
                .disabled(!isFormValid)
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(toolbarLabel(for: focusedField)) {
                    focusedField = nextField(after: focusedField)
                }
            }
        }
    }
    
    var isFormValid: Bool {
        guard cardNumber.replacingOccurrences(of: " ", with: "").count >= 13
        else { return false }
        
        let nameComponents = cardholderName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .whitespaces)
        guard nameComponents.count >= 2 else { return false }
        
        let expiryRegex = try? NSRegularExpression(
            pattern: "^(0[1-9]|1[0-2])/\\d{2}$"
        )
        let expiryMatch = expiryRegex?.firstMatch(
            in: expiryDate,
            range: NSRange(location: 0, length: expiryDate.utf16.count)
        )
        guard expiryMatch != nil else { return false }
        
        guard cvv.count == 3 || cvv.count == 4 else { return false }
        
        return true
    }
    
    func toolbarLabel(for field: Field?) -> String {
        switch field {
        case .cvv:
            return "Done"
        default:
            return "Next"
        }
    }
    func nextField(after field: Field?) ->Field? {
        switch field {
        case .cardNumber:
            return .cardholderName
        case .cardholderName:
            return .expiryDate
        case .expiryDate:
            return .cvv
        default:
            return nil
        }
    }
}

extension CardForm {
    struct CreditCardView: View {
        let cardNumber: String
        let cardholderName: String
        let expiryDate: String
        let cvv: String
        let flipped: Bool
        
        @State var op = 1.0
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.5),
                            Color.blue.opacity(0.9)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .shadow(radius: 6, y: 4)
                
                VStack {
                    if flipped {
                        // CVV Back Side
                        VStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color(white: 0.3))
                                .frame(height: 50)
                                .padding(.top)
                            Spacer()
                            (
                                Text("CVV: ").font(.caption)
                                + Text(cvv).font(.title3).fontDesign(.monospaced)
                            )
                            .padding()
                        }
                        .opacity(1.0 - op)
                        .animation(.easeInOut(duration: 0.2), value: op)
                        .rotation3DEffect(
                            .degrees(180),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                    } else {
                        // Front Side
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Spacer()
                                Image(systemName: "creditcard.fill")
                                    .font(.title)
                            }
                            
                            Spacer()
                            
                            Text(formatCardNumber(cardNumber))
                                .font(.title3)
                                .fontDesign(.monospaced)
                                .tracking(1)
                            HStack {
                                Text(cardholderName.isEmpty ? "John Doe" : cardholderName)
                                    .font(.caption)
                                    .textCase(.uppercase)
                                
                                Spacer()
                                
                                Text(expiryDate)
                                    .font(.caption)
                            }
                        }
                        .opacity(op)
                        .animation(.easeInOut(duration: 0.2), value: op)
                        .padding()
                    }
                }
            }
            .environment(\.colorScheme, .light)
            .dynamicTypeSize(.medium)
            .foregroundStyle(.regularMaterial)
            .aspectRatio(1.6, contentMode: .fit)
            .rotation3DEffect(
                .degrees(flipped ? 180 : 0),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
            .animation(.bouncy, value: flipped)
            .onChange(of: flipped) {
                op = flipped ? 0.0 : 1.0
            }
        }
        
        private func formatCardNumber(_ number: String) -> String {
            let cleaned = number.replacingOccurrences(of: " ", with: "")
            let groups = stride(from: 0, to: cleaned.count, by: 4)
                .map { startIndex in
                    let endIndex = min(startIndex + 4, cleaned.count)
                    return String(cleaned[cleaned.index(cleaned.startIndex, offsetBy: startIndex)..<cleaned.index(cleaned.startIndex, offsetBy: endIndex)])
                }
            return groups.joined(separator: " ")
        }
    }
}

#Preview {
    NavigationStack {
        CardForm(input: .constant(""))
    }
}
