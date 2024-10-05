//
//  LoginRepositorySpec.swift
//  SawitPRO_tech_testTests
//
//  Created by Daniel Sunarjo on 05/10/24.
//

@testable import SawitPRO_tech_test
import XCTest
import Combine

final class LoginRepositoryTests: XCTestCase {
    var sut: LoginRepository!
    var mockUserDataManager: MockUserDataManager!
    var cancellables: Set<AnyCancellable>!
    let di: DependencyContainer = .shared

    override func setUp() {
        super.setUp()
        prepareDependencies()
    }

    override func tearDown() {
        sut = nil
        mockUserDataManager = nil
        cancellables = nil
        super.tearDown()
    }

    func testRegisterSuccess() {
        let expectation = XCTestExpectation(description: "User registered successfully")
        
        sut.register(username: "testUser", password: "testPassword")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but received error: \(error)")
                }
            }, receiveValue: {
                XCTAssertEqual(self.mockUserDataManager.users.count, 1)
                XCTAssertEqual(self.mockUserDataManager.users.first?.username, "testUser")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testRegisterFailure() {
        mockUserDataManager.shouldReturnError = true
        let expectation = XCTestExpectation(description: "User registration failed")
        
        sut.register(username: "testUser", password: "testPassword")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error.localizedDescription, "Creation Error")
                    expectation.fulfill()
                }
            }, receiveValue: { })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchWithUsernameSuccess() {
        let expectation = XCTestExpectation(description: "Fetched user successfully")

        // Add a user to the mock data manager
        mockUserDataManager.users.append(UserData(username: "testUser", password: "testPassword"))

        sut.fetchWithUsername(username: "testUser")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but received error: \(error)")
                }
            }, receiveValue: { users in
                XCTAssertEqual(users.count, 1)
                XCTAssertEqual(users.first?.username, "testUser")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchWithUsernameFailure() {
        mockUserDataManager.shouldReturnError = true
        let expectation = XCTestExpectation(description: "Fetch failed")
        
        sut.fetchWithUsername(username: "nonExistentUser")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error.localizedDescription, "Fetch Error")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but received success")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
    
    private func prepareDependencies() {
        DITestHelper.registerTestDependencies()
        
        mockUserDataManager = MockUserDataManager()
        cancellables = []
        
        di.register({
            self.mockUserDataManager
        }, for: UserDataManagerProtocol.self)
        
        sut = LoginRepository()
    }
}
