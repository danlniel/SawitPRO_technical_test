//
//  LoginViewModelSpec.swift
//  SawitPRO_tech_testTests
//
//  Created by Daniel Sunarjo on 05/10/24.
//

@testable import SawitPRO_tech_test
import XCTest
import Combine

final class LoginViewModelTests: XCTestCase {
    var sut: LoginViewModel!
    var mockRepository: MockLoginRepository!
    var mockEncryptionManager: MockEncryptionManager!
    var cancellables: Set<AnyCancellable>!
    let di: DependencyContainer = .shared

    override func setUp() {
        super.setUp()
        prepareDependencies()
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        mockEncryptionManager = nil
        cancellables = nil
        super.tearDown()
    }

    func testLoginSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Login Success")
        let userData = Factories.createUserData()
        sut.username = userData.username
        sut.password = userData.password
        
        mockRepository.users = [userData]
        mockEncryptionManager.decryptResult = .success(userData.password)

        // When
        sut.login {
            expectation.fulfill()
        }

        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(sut.result, .success("Login success")) // Adjust according to your SaveResult enum
        XCTAssertTrue(sut.isSnackbarShowing)
    }

    func testLoginFailure() {
        // Given
        let userData = Factories.createUserData()
        sut.username = userData.username
        sut.password = "wrongpass"
        
        mockRepository.users = [userData]
        mockEncryptionManager.decryptResult = .success(userData.password)

        // Then
        // Since there is no callback, we wait for a second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.sut.result, .failure("Login Failed"))
            XCTAssertTrue(self.sut.isSnackbarShowing)
        }
    }

    func testRegisterSuccess() {
        // Given
        let userData = Factories.createUserData()
        sut.username = userData.username
        sut.password = userData.password

        mockRepository.users = []
        mockEncryptionManager.encryptResult = .success(userData.password)
        
        // When
        sut.register()

        // Then        
        // Since there is no callback, we wait for a second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.sut.result, .success("User has been successfully registered"))
            XCTAssertTrue(self.sut.isSnackbarShowing)
        }
    }

    func testRegisterFailure_UserAlreadyExists() {
        // Given
        let userData = Factories.createUserData()
        sut.username = userData.username
        sut.password = userData.password

        mockRepository.users = [userData]
        mockEncryptionManager.encryptResult = .success(userData.password)
        
        // When
        sut.register()

        // Then
        // Since there is no callback, we wait for a second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.sut.result, .failure("The Username has been taken"))
            XCTAssertTrue(self.sut.isSnackbarShowing)
        }
    }

    func testRegisterFailure() {
        // Given
        let userData = Factories.createUserData()
        sut.username = userData.username
        sut.password = userData.password

        mockRepository.shouldFailRegister = true
        mockEncryptionManager.encryptResult = .success(userData.password)
        
        // When
        sut.register()

        // Then
        // Since there is no callback, we wait for a second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.sut.result, .failure("Failed to process data"))
            XCTAssertTrue(self.sut.isSnackbarShowing)
        }
    }
    
    private func prepareDependencies() {
        DITestHelper.registerTestDependencies()
        
        mockRepository = .init()
        mockEncryptionManager = .init()
        cancellables = []
        
        di.register({
            self.mockRepository
        }, for: LoginRepositoryProtocol.self)
        di.register({
            self.mockEncryptionManager
        }, for: EncryptionManagerProtocol.self)
        
        sut = LoginViewModel()
    }
}
