//
//  FirestoreManager.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import FirebaseFirestore
import Combine

class FirestoreManager<T: FirestoreModel> {
    private let db = Firestore.firestore()
    private var collectionName: String = ""

    init(collectionName: String) {
        self.collectionName = collectionName
    }

    // MARK: - Create/Update
    func save(model: T) -> Future<Void, Error> {
        return Future { promise in
            let documentData = model.toDictionary()
            self.db.collection(self.collectionName).document(model.id).setData(documentData) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
    }

    // MARK: - Read by ID
    func get(byId id: String) -> Future<T, Error> {
        return Future { promise in
            self.db.collection(self.collectionName).document(id).getDocument { (document, error) in
                if let document = document, document.exists {
                    if let data = document.data(), let model = T(from: data) {
                        promise(.success(model))
                    } else {
                        promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data format error."])))
                    }
                } else {
                    promise(.failure(error ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist."])))
                }
            }
        }
    }

    // MARK: - Delete by ID
    func delete(byId id: String) -> Future<Void, Error> {
        return Future { promise in
            self.db.collection(self.collectionName).document(id).delete { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
    }

    // MARK: - Fetch All
    func getAll() -> Future<[T], Error> {
        return Future { promise in
            self.db.collection(self.collectionName).getDocuments { (snapshot, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    var models: [T] = []
                    snapshot?.documents.forEach { document in
                        var modelData = document.data()
                         modelData["id"] = document.documentID // Add the document ID to the dictionary
                         if let model = T(from: modelData) {
                             models.append(model)
                         }
                    }
                    promise(.success(models))
                }
            }
        }
    }
    
    // MARK: - Batch Operations
    func performBatch(operations: @escaping (WriteBatch, CollectionReference) -> Void) -> Future<Void, Error> {
        return Future { promise in
            let dbColletion: CollectionReference = self.db.collection(self.collectionName)
            let batch = self.db.batch()
            operations(batch, dbColletion)
            batch.commit { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
    }
}
