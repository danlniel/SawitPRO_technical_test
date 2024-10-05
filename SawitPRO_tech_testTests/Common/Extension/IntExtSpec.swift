//
//  IntExtSpec.swift
//  SawitPRO_tech_testTests
//
//  Created by Daniel Sunarjo on 05/10/24.
//

@testable import SawitPRO_tech_test
import SwiftUI
import XCTest
import Combine

final class IntExtSpec: XCTestCase {
    func testToStringWithPositiveNumber() {
        let number = 123
        let result = number.toString()
        XCTAssertEqual(result, "123", "The toString() method should return '123' for the integer 123.")
    }
    
    func testToStringWithNegativeNumber() {
        let number = -456
        let result = number.toString()
        XCTAssertEqual(result, "-456", "The toString() method should return '-456' for the integer -456.")
    }
    
    func testToStringWithZero() {
        let number = 0
        let result = number.toString()
        XCTAssertEqual(result, "0", "The toString() method should return '0' for the integer 0.")
    }
}
