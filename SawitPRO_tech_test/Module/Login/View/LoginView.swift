//
//  Login.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    
    let onSuccessLogin: () -> Void
    
    init(onSuccessLogin: @escaping () -> Void) {
        self.onSuccessLogin = onSuccessLogin
        _viewModel = StateObject(
            wrappedValue: DependencyContainer.shared.resolve(LoginViewModel.self)!
        )
    }
    
    var body: some View {
        ZStack {
            VStack {
                Image(RegisteredImage.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.7)
                TextField(String.localized(LocalizableKeys.username), text: $viewModel.username)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .keyboardType(.asciiCapable)
                    .onChange(of: viewModel.username) {
                        viewModel.username = viewModel.username.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                SecureField(String.localized(LocalizableKeys.password), text: $viewModel.password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .onChange(of: viewModel.password) {
                        viewModel.password = viewModel.password.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                HStack {
                    Button(action: {
                        viewModel.login {
                            onSuccessLogin()
                        }
                    }) {
                        Text(String.localized(LocalizableKeys.login))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Button(action: {
                        viewModel.register()
                    }) {
                        Text(String.localized(LocalizableKeys.register))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)
            
            // Snackbar
            createSnackbar(result: viewModel.result)
        }
    }
    
    @ViewBuilder
    private func createSnackbar(result: SaveResult) -> some View {
        switch result {
        case .success(let message):
            Snackbar(
                message: message,
                type: .success,
                isShowing: $viewModel.isSnackbarShowing
            )
        case .failure(let message):
            Snackbar(
                message: message,
                type: .error,
                isShowing: $viewModel.isSnackbarShowing
            )
        case .none: EmptyView()
        }
    }
}

#Preview {
    LoginView(onSuccessLogin: {})
}
