//
//  SwiftDataManager.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import SwiftUI
import SwiftData
import Combine

final class SwiftDataManager<T: PersistentModel>: ObservableObject {
    private lazy var context: ModelContextProtocol = {
        DependencyContainer.shared.resolve(ModelContextProtocol.self)!
    }()
    private var cancellables = Set<AnyCancellable>()
    
    // Method to create a new instance of the model
    func create(model: T) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.context.insert(model)
            self.save().sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    promise(.failure(error))
                case .finished:
                    promise(.success(()))
                }
            }, receiveValue: {}).store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    // Method to fetch all instances of the model
    func fetchAll() -> AnyPublisher<[T], Error> {
        Future { promise in
            do {
                let results = try self.context.fetch(FetchDescriptor<T>())
                promise(.success(results))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetch(using fetchRequest: FetchDescriptor<T>) -> AnyPublisher<[T], Error> {
        Future { promise in
            do {
                let results = try self.context.fetch(fetchRequest)
                promise(.success(results))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Method to delete an instance of the model
    func delete(model: T) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.context.delete(model)
            self.save().sink(
                receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    promise(.failure(error))
                case .finished:
                    promise(.success(()))
                }
            }, receiveValue: {}).store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    // Method to save changes to the context
    func save() -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                try self.context.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
