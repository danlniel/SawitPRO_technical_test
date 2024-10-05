//
//  HomeCoordinator.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import SwiftUI

struct HomeCoordinator: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HomeView()
            .navigationBarItems(
                leading: Button(
                    "Sign out",
                    action: {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            )
    }
}
