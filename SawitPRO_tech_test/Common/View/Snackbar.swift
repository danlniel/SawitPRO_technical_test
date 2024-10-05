//
//  Snackbar.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import SwiftUI

enum SnackbarType {
    case success
    case error
}

enum SaveResult: Equatable {
    case success(String)
    case failure(String)
    case none
}

struct Snackbar: View {
    let message: String
    let type: SnackbarType
    @Binding var isShowing: Bool
    
    var backgroundColor: Color {
        switch type {
        case .success:
            return Color.green
        case .error:
            return Color.red
        }
    }
    
    var body: some View {
        if isShowing {
            VStack {
                Spacer()
                HStack {
                    Text(message)
                        .foregroundColor(.white)
                        .padding()
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                .background(backgroundColor)
                .cornerRadius(8)
                .padding()
                .transition(.slide)
                .animation(.easeInOut, value: isShowing)
                .onAppear {
                    hideAfterDelay()
                }
            }
        }
    }
    
    private func hideAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                isShowing = false
            }
        }
    }
}

#Preview {
    @State var isShowingSuccess: Bool = true
    
    return VStack {
        Snackbar(message: "test", type: .success, isShowing: $isShowingSuccess)
        Snackbar(message: "test", type: .error, isShowing: $isShowingSuccess)
    }
}
