//
//  RootViewController.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import SwiftUI
import SwiftData

struct RootCoordinator: View {
    @Environment(\.modelContext) private var context
    
    private let di: DependencyContainer = .shared
    
    var body: some View {
        LoginCoordinator()
            .onLoad {
                di.registerContext(context: context)
            }
    }
}
