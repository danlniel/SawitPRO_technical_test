//
//  HomeViewModel.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import Combine
import SwiftData
import SwiftUI
import FirebaseFirestore

enum HomeState {
    case online
    case offline
    case syncing
}

class HomeViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isFilterModalPresented: Bool = false
    @Published var isAddItemModalPresented: Bool = false
    @Published var minPrice: String = "0"
    @Published var maxPrice: String = Int.max.toString()
    @Published var result: SaveResult = .none
    @Published var isSnackbarShowing: Bool = false
    @Published var productDataList: [ProductData] = []
    @Published var selectedProduct: ProductData? = nil
    @Published var homeState: HomeState = .offline
    
    var filteredProductList: [ProductData] {
        return productDataList.filter { product in
            let minPriceValue: Int = minPrice.toInt()
            let maxPriceValue: Int = maxPrice.toInt()
            let matchesSearchText = searchText.isEmpty || product.name.localizedCaseInsensitiveContains(searchText)
            let matchesPriceRange = product.price >= minPriceValue && product.price <= maxPriceValue
            return matchesSearchText && matchesPriceRange
        }
    }
    private var cancellables = Set<AnyCancellable>()
    
    // Dependencies
    private lazy var connectivity: Connectivity = {
        DependencyContainer.shared.resolve(Connectivity.self)!
    }()
    private lazy var repo: HomeRepositoryProtocol = {
        DependencyContainer.shared.resolve(HomeRepositoryProtocol.self)!
    }()
    
    func update(_ source: [ProductData]) {
        productDataList = source
    }
    
    func start() {
        connectivity.start { [weak self] isConnected, state in
            self?.homeState = isConnected ? .online : .offline
            if isConnected {
                self?.syncWithFirestore()
            }
        }
    }
    
    func addProduct(data: ProductData) {
        repo.createProduct(data: data)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        self.showSnackbar(.success(String.localized(LocalizableKeys.productHasbeenAdded)))
                    case .failure(_):
                        self.showSnackbar(.failure(String.localized(LocalizableKeys.failedAddProduct)))
                    }
                }, receiveValue: { _ in }
            )
            .store(in: &cancellables)
    }
    
    func removeProduct(data: ProductData) {
        repo.removeProduct(data: data)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        self.showSnackbar(.success(String.localized(LocalizableKeys.productHasBeenDeleted)))
                    case .failure(_):
                        self.showSnackbar(.failure(String.localized(LocalizableKeys.failedRemoveProduct)))
                    }
                }, receiveValue: { _ in }
            )
            .store(in: &cancellables)
    }
    
    func saveProduct() {
        repo.saveProduct()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        self.showSnackbar(.success(String.localized(LocalizableKeys.productHasBeenUpdated)))
                    case .failure(_):
                        self.showSnackbar(.failure(String.localized(LocalizableKeys.failedUpdateProduct)))
                    }
                }, receiveValue: { _ in }
            )
            .store(in: &cancellables)
    }
    
    private func syncWithFirestore() {
        // Fetch products from Firestore
        homeState = .syncing
        repo.getAllProductFM()
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(_) = completion {
                        self?.showSnackbar(.failure(String.localized(LocalizableKeys.syncFailed)))
                    }
                    self?.homeState = .online
                },
                receiveValue: { [weak self] productFMs in
                    guard let self = self else { return }
                    syncFirestoreWithSwiftDataProccess(productFMs)
                }
            )
            .store(in: &cancellables)
    }
    
    
    private func syncFirestoreWithSwiftDataProccess(_ productFMs: [ProductFM]) {
        // Create a set of product names from Firestore for quick lookup
        let firestoreProductNames = Set(productFMs.map { $0.name })
        
        // Prepare to perform batch operations
        let batchOperations = { (batch: WriteBatch, collectionRef: CollectionReference) in
            // Check each product in SwiftData
            for product in self.productDataList {
                if firestoreProductNames.contains(product.name) {
                    // Product exists in Firestore; check for price update
                    if let firestoreProduct = productFMs.first(where: { $0.name == product.name }), firestoreProduct.price != product.price {
                        // Update the product price in Firestore
                        let updatedProduct = ProductFM(id: firestoreProduct.id, name: product.name, price: product.price)
                        let documentRef = collectionRef.document(updatedProduct.id)
                        batch.setData(updatedProduct.toDictionary(), forDocument: documentRef)
                    }
                } else {
                    // Product doesn't exist in Firestore; create new document
                    let newProduct = ProductFM(name: product.name, price: product.price)
                    let documentRef = collectionRef.document(newProduct.id)
                    batch.setData(newProduct.toDictionary(), forDocument: documentRef)
                }
            }

            // Check for products in Firestore that are not in SwiftData
            for productFM in productFMs {
                if !self.productDataList.contains(where: { $0.name == productFM.name }) {
                    // Product in Firestore not found in SwiftData; delete it
                    let documentRef = collectionRef.document(productFM.id)
                    batch.deleteDocument(documentRef)
                }
            }
        }

        // Execute the batch operations
        repo.performBatch(operations: batchOperations)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(_) = completion {
                    self?.showSnackbar(.failure(String.localized(LocalizableKeys.syncFailed)))
                } else {
                    self?.showSnackbar(.success(String.localized(LocalizableKeys.syncSuccess)))
                }
                self?.homeState = .online
            }, receiveValue: { _ in })
            .store(in: &self.cancellables)
    }
    
    private func showSnackbar(_ result: SaveResult) {
        self.result = result
        isSnackbarShowing = true
    }
}
