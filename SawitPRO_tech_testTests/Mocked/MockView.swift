//
//  MockView.swift
//  SawitPRO_tech_testTests
//
//  Created by Daniel Sunarjo on 05/10/24.
//

@testable import SawitPRO_tech_test
import SwiftUI

struct MockView: View {
    var onLoadAction: () -> Void

    var body: some View {
        Color.clear
            .onLoad(perform: onLoadAction)
    }
}
