//
//  SwiftDataManagerSpec.swift
//  SawitPRO_tech_testTests
//
//  Created by Daniel Sunarjo on 05/10/24.
//

@testable import SawitPRO_tech_test
import XCTest
import Combine
import SwiftData

final class SwiftDataManagerTests: XCTestCase {
    var sut: SwiftDataManager<UserData>!
    var mockContext: MockModelContext!
    var cancellables: Set<AnyCancellable>!
    let di: DependencyContainer = .shared

    override func setUp() {
        super.setUp()
        prepareDependencies()
    }

    override func tearDown() {
        sut = nil
        mockContext = nil
        cancellables = nil
        super.tearDown()
    }

    func testCreateModel() {
        let model = Factories.createUserData()

        let expectation = XCTestExpectation(description: "Model created successfully")

        sut.create(model: model)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success, but got failure.")
                }
            }, receiveValue: {
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockContext.saveCalled, "Save should have been called.")
    }

    func testFetchAllModels() {
        let model = Factories.createUserData()
        mockContext.insert(model)

        let expectation = XCTestExpectation(description: "Fetched models successfully")

        sut.fetchAll()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success, but got failure.")
                }
            }, receiveValue: { models in
                XCTAssertEqual(models.count, 1, "Should have fetched one model.")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testDeleteModel() {
        let model = Factories.createUserData()
        mockContext.insert(model)

        let expectation = XCTestExpectation(description: "Model deleted successfully")

        sut.delete(model: model)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success, but got failure.")
                }
            }, receiveValue: {
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(mockContext.models[String(describing: UserData.self)], "Model should have been deleted.")
        XCTAssertTrue(mockContext.saveCalled, "Save should have been called after deletion.")
    }
    
    func testFetchWithDescriptor() {
        let fetchRequest = FetchDescriptor<UserData>()
        let model = Factories.createUserData()
        mockContext.insert(model)

        let expectation = XCTestExpectation(description: "Fetch with descriptor should succeed")

        sut.fetch(using: fetchRequest).sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                XCTFail("Fetch with descriptor failed with error: \(error)")
            case .finished:
                expectation.fulfill()
            }
        }, receiveValue: { models in
            XCTAssertEqual(models.count, 1, "Should have fetched one model.")
        }).store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSave() {
        let model = Factories.createUserData()
        let saveExpectation = expectation(description: "Save should succeed")

        sut.save().sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                XCTFail("Save failed with error: \(error)")
            case .finished:
                saveExpectation.fulfill()
            }
        }, receiveValue: {}).store(in: &cancellables)

        wait(for: [saveExpectation], timeout: 1.0)
    }
    
    private func prepareDependencies() {
        DITestHelper.registerTestDependencies()
        
        mockContext = MockModelContext()
        cancellables = []
        
        di.register({
            self.mockContext
        }, for: ModelContextProtocol.self)
        
        sut = SwiftDataManager()
    }
}
