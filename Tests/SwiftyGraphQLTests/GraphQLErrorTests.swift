// GraphQLErrorTests.swift
// Copyright © 2022 hiimtmac

import XCTest
@testable import SwiftyGraphQL

class GraphQLErrorTests: XCTestCase {
    func testLocalized() {
        let error = GQLError(
            message: "hello there",
            locations: nil,
            fields: nil,
            errorType: nil,
            validationErrorType: nil
        )
        XCTAssertEqual(error.localizedDescription, "Unrecoverable GraphQL© query/mutation: hello there")
    }

    func testFailureReason() {
        let error = GQLError(
            message: "hello there",
            locations: nil,
            fields: nil,
            errorType: "ValidationError",
            validationErrorType: nil
        )
        XCTAssertEqual(error.failureReason, "ValidationError")
    }

    func testRecoverySuggestion() {
        let error = GQLError(
            message: "hello there",
            locations: [.init(line: 19, column: 2)],
            fields: ["mutation", "onboard"],
            errorType: nil,
            validationErrorType: nil
        )
        XCTAssertEqual(error.recoverySuggestion, "Locations: Ln: 19 / Col: 2 | Fields: mutation, onboard")
    }

    static var allTests = [
        ("testLocalized", testLocalized),
        ("testFailureReason", testFailureReason),
        ("testRecoverySuggestion", testRecoverySuggestion),
    ]
}
