//
//  EmptyNavigationLink.swift
//  SawitPRO_tech_test
//
//  Created by Daniel Sunarjo on 03/10/24.
//

import SwiftUI

struct EmptyNavigationLink<Destination>: View where Destination: View {
    let destination: Destination
    let isActive: Binding<Bool>
    
    init(destination: Destination, isActive: Binding<Bool>) {
        self.destination = destination
        self.isActive = isActive
    }
    
    var body: some View {
        NavigationLink(
            destination: destination,
            label: {
                EmptyView()
            }
        )
    }
}
