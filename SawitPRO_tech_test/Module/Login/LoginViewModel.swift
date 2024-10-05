//
//  LoginViewModel.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import Combine
import SwiftData
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var result: SaveResult = .none
    @Published var registrationSuccess: Bool?
    @Published var isSnackbarShowing: Bool = false
    @Published var username: String = ""
    @Published var password: String = ""
    
    private lazy var repo: LoginRepositoryProtocol = {
        DependencyContainer.shared.resolve(LoginRepositoryProtocol.self)!
    }()
    private var user: User = .init(username: "", password: "")
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    func login(successCompletion: @escaping () -> Void) {
        repo.fetchWithUsername(username: user.username)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Handle finished operation later here")
                    case .failure(_):
                        self.showSnackbar(.failure(String.localized(LocalizableKeys.loginFailed)))
                    }
                }, receiveValue: { users in
                    _ = users.first?.password.decrypt().map { decryptedString in
                        if decryptedString == self.password {
                            self.showSnackbar(.success(String.localized(LocalizableKeys.loginSuccess)))
                            successCompletion()
                        } else {
                            self.showSnackbar(.failure(String.localized(LocalizableKeys.loginFailed)))
                        }
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func register() {
        repo.fetchWithUsername(username: user.username)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Handle finsihed operation later here")
                    case .failure(_):
                        self.showSnackbar(.failure(String.localized(LocalizableKeys.failedProcessData)))
                    }
                }, receiveValue: { users in
                    if users.isEmpty {
                        self.registerUser()
                    } else {
                        self.showSnackbar(.failure(String.localized(LocalizableKeys.usernameHasBeenRegistered)))
                    }
                    
                }
            )
            .store(in: &cancellables)
    }
    
    private func registerUser() {
        repo.register(username: user.username, password: user.encryptedPassword())
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        self.showSnackbar(.success(String.localized(LocalizableKeys.userHasBeenAdded)))
                    case .failure(_):
                        self.showSnackbar(.failure(String.localized(LocalizableKeys.failedAddUser)))
                    }
                },
                receiveValue: {}
            )
            .store(in: &self.cancellables)
    }
    
    private func bind() {
        $username
            .map { $0 }
            .assign(to: \.user.username, on: self)
            .store(in: &cancellables)
        $password
            .map { $0 }
            .assign(to: \.user.password, on: self)
            .store(in: &cancellables)
    }
    
    private func showSnackbar(_ result: SaveResult) {
        self.result = result
        isSnackbarShowing = true
    }
}
