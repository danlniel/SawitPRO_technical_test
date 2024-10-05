//
//  HomeRepository.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import Foundation
import SwiftData
import Combine
import FirebaseFirestore

protocol HomeRepositoryProtocol {
    func createProduct(data: ProductData) -> AnyPublisher<Void, Error>
    func removeProduct(data: ProductData) -> AnyPublisher<Void, Error>
    func saveProduct() -> AnyPublisher<Void, Error>
    func getAllProductFM() -> Future<[ProductFM], Error>
    func performBatch(operations: @escaping (WriteBatch, CollectionReference) -> Void) -> Future<Void, Error>
}

class HomeRepository: ObservableObject {
    private lazy var dataManager: SwiftDataManager<ProductData> = {
        DependencyContainer.shared.resolve(SwiftDataManager<ProductData>.self)!
    }()
    private lazy var firestoreManager: FirestoreManager<ProductFM> = {
        DependencyContainer.shared.resolve(FirestoreManager<ProductFM>.self)!
    }()
    
    func createProduct(data: ProductData) -> AnyPublisher<Void, Error> {
        return dataManager.create(model: data)
    }
    
    func removeProduct(data: ProductData) -> AnyPublisher<Void, Error> {
        return dataManager.delete(model: data)
    }
    
    func saveProduct() -> AnyPublisher<Void, Error> {
        return dataManager.save()
    }
    
    func getAllProductFM() -> Future<[ProductFM], Error> {
        return firestoreManager.getAll()
    }
    
    func performBatch(operations: @escaping (WriteBatch, CollectionReference) -> Void) -> Future<Void, Error> {
        return firestoreManager.performBatch(operations: operations)
    }
}

extension HomeRepository: HomeRepositoryProtocol {}
