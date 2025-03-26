//
//  AddressSearch.swift
//  QuickSwift Store
//
//  Created by Vinicius Nakamura on 26/03/25.
//

import SwiftUI
import MapKit

struct AddressSearch: View {
    @Binding var address: String
    
    @State private var searchText = ""
    @State private var isSearching = true
    @State private var suggestions = [MKLocalSearchCompletion]()
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = AddressSearchViewModel()
    
    var body: some View {
        List(viewModel.results) { result in
            Button {
                address = "\(result.title) \(result.subtitle)"
                dismiss()
            } label: {
                Text(result.title).bold()
                + Text(" - ")
                + Text(result.subtitle)
            }
            .buttonStyle(.plain)
        }
        .searchable(text: $viewModel.searchableText, isPresented: $isSearching)
        .onReceive(
            viewModel.$searchableText.debounce(
                for: .seconds(0.3),
                scheduler: DispatchQueue.main
            )
        ) {
            viewModel.searchAddress($0)
        }
        .navigationTitle("Delivery Address")
    }
}

class AddressSearchViewModel: NSObject, ObservableObject {
    struct AddressResult: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
    }
    
    @Published private(set) var results: Array<AddressResult> = []
    @Published var searchableText = ""

    private lazy var localSearchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        return completer
    }()
    
    func searchAddress(_ searchableText: String) {
        guard searchableText.isEmpty == false else { return }
        localSearchCompleter.queryFragment = searchableText
    }
}
extension AddressSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Task { @MainActor in
            results = completer.results.map {
                AddressResult(title: $0.title, subtitle: $0.subtitle)
            }
        }
    }
    
    func completer(
        _ completer: MKLocalSearchCompleter,
        didFailWithError error: Error
    ) {
        print(error)
    }
}

#Preview {
    @Previewable @State var address = ""
    NavigationStack {
        AddressSearch(address: .constant(""))
    }
}
