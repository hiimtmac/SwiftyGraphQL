//
//  GraphQLErrorTests.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2018-10-24.
//  Copyright © 2018 hiimtmac. All rights reserved.
//

import XCTest
@testable import SwiftyGraphQL

class GraphQLErrorTests: XCTestCase {

    func testLocalized() {
        let error = GraphQLError(message: "hello there", locations: nil, fields: nil, errorType: nil, validationErrorType: nil)
        XCTAssertEqual(error.localizedDescription, "Unrecoverable GraphQL© query/mutation: hello there")
    }
    
    func testFailureReason() {
        let error = GraphQLError(message: "hello there", locations: nil, fields: nil, errorType: "ValidationError", validationErrorType: nil)
        XCTAssertEqual(error.failureReason, "ValidationError")
    }
    
    func testRecoverySuggestion() {
        let error = GraphQLError(message: "hello there", locations: [GraphQLError.Location(line: 19, column: 2)], fields: ["mutation", "onboard"], errorType: nil, validationErrorType: nil)
        XCTAssertEqual(error.recoverySuggestion, "Locations: Ln: 19 / Col: 2 | Fields: mutation, onboard")
    }
    
    static var allTests = [
        ("testLocalized", testLocalized),
        ("testFailureReason", testFailureReason),
        ("testRecoverySuggestion", testRecoverySuggestion)
    ]
}
