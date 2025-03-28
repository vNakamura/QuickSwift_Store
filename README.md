# QuickSwift Store

A SwiftUI e-commerce app demonstration showcasing modern iOS development techniques.

## Project Status

This is an active work-in-progress project built to refresh SwiftUI skills and demonstrate iOS development capabilities.

## Project Checklist

* [x] Retrieve list of products from [FakeStore API](https://fakestoreapi.com/)
* [x] Lazy loading and caching for product images
* [x] Related items suggestion feature
* [x] Add to cart interaction
* [x] Change cart items quantity and remove from cart
* [x] Checkout screen
* [x] User tab with order history
* [ ] Favorites list
* [ ] Custom UI/UX improvements
* [ ] Animations
* [ ] Unit and UI tests

## Technical Implementation

- Built with **SwiftUI** and targeting the latest iOS features
- Using **SwiftData** for local persistence of cart items and user data
- All cart and order functionality handled locally with persistence
- Implements modern Swift concurrency with async/await

## API Note

The app uses [FakeStore API](https://fakestoreapi.com/) which provides product data but has static content. While the API includes endpoints for create, update, and delete operations, changes don't persist server-side. This limitation is addressed by implementing local storage with SwiftData.

## Requirements

- Xcode 16+
- iOS 18.2+

## Getting Started

1. Clone the repository
2. Open in Xcode 16
3. Build and run on iOS 18.2+ simulator or device

## Future Plans

The project will continue to evolve as more features are implemented according to the checklist above.
