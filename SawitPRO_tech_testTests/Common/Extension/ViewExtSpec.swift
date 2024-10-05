//
//  ViewExtSpec.swift
//  SawitPRO_tech_testTests
//
//  Created by Daniel Sunarjo on 05/10/24.
//

import SwiftUI
import XCTest
import Combine

final class ViewExtSpec: XCTestCase {
    func testOnLoad() {
        // Expectation to verify that the action is called.
        let expectation = XCTestExpectation(description: "onLoad action should be called")
        let action = {
            expectation.fulfill()
        }

        // Create an instance of the TestableView with the mock action.
        let testView = MockView(onLoadAction: action)
        // Render the view inside a ViewHosting environment.
        let controller = UIHostingController(rootView: testView)
        // Simulate the view appearing.
        controller.viewDidAppear(true)

        // Wait for the expectation to be fulfilled.
        wait(for: [expectation], timeout: 1.0)
    }
}
