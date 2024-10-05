//
//  LoginCoordinator.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import SwiftUI
import FirebaseFirestore

struct LoginCoordinator: View {
    @Environment(\.openURL) var openURL
    
    @State private var isHomePresented = false
    
    var body: some View {
        NavigationStack {
            LoginView() {
                isHomePresented = true
            }
        }
        .fullScreenCover(
            isPresented: $isHomePresented,
            content: {
                NavigationStack {
                    HomeCoordinator()
                }
            }
        )
    }
}
