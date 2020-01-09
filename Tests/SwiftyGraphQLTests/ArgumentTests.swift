//
//  ParameterTests.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2018-10-24.
//  Copyright © 2018 hiimtmac. All rights reserved.
//

import XCTest
@testable import SwiftyGraphQL

class ArgumentTests: XCTestCase {
    
    func testParameters() {
        let node = GQLNode("test")
            .withArgument(named: "since", value: 20)
            .withArgument(named: "name", value: "taylor")
            .withArgument(named: "true", value: true)
        
        XCTAssertEqual(node.gqlQueryString, #"test(name: "taylor", since: 20, true: true)"#)
    }
    
    func testParameterOverride() {
        let node = GQLNode("test")
            .withArgument(named: "since", value: 20)
            .withArgument(named: "name", value: "taylor")
            .withArgument(named: "since", value: nil as Int?)
            .withArgument(named: "ok", value: true)
            .withArgument(named: "name", value: "difficult")
        
        XCTAssertEqual(node.gqlQueryString, #"test(name: "difficult", ok: true)"#)
    }
    
    func testQuoteEscaped() {
        let val = #"thing"thing"#.gqlArgumentValue
        let compare = #""thing\"thing""#
        XCTAssertEqual(val, compare)
    }

    func testSlashEscaped() {
        let val = #"thing\thing"#.gqlArgumentValue
        let compare = #""thing\\thing""#
        XCTAssertEqual(val, compare)
    }

    func testSlashQuoteEscaped() {
        let val = #"thing\"thing"#.gqlArgumentValue
        let compare = #""thing\\\"thing""#
        XCTAssertEqual(val, compare)
    }

    func testParametersEncoded() {
        let val1 = #"thing"thing"#
        let val2 = #"thing\thing"#
        let val3 = #"thing\"thing"#
        
        let node = GQLNode("test")
            .withArgument(named: "since", value: val1)
            .withArgument(named: "ok", value: val2)
            .withArgument(named: "yes", value: val3)
            .withArgument(named: "sure", value: 4)
            .withArgument(named: "normal", value: "also")

        XCTAssertEqual(node.gqlQueryString, #"test(normal: "also", ok: "thing\\thing", since: "thing\"thing", sure: 4, yes: "thing\\\"thing")"#)
    }
    
    func testParametersDict() {
        let val1 = #"thing"thing"#
        let val2 = #"thing\thing"#
        let val3 = #"thing\"thing"#
        
        let node = GQLNode("test")
            .withArgument(named: "since", value: val1)
            .withArguments(["ok": val2, "yes": val3, "sure": 4])
            .withArgument(named: "normal", value: "also")

        XCTAssertEqual(node.gqlQueryString, #"test(normal: "also", ok: "thing\\thing", since: "thing\"thing", sure: 4, yes: "thing\\\"thing")"#)
    }

    static var allTests = [
        ("testParameters", testParameters),
        ("testParameterOverride", testParameterOverride),
        ("testQuoteEscaped", testQuoteEscaped),
        ("testSlashEscaped", testSlashEscaped),
        ("testSlashQuoteEscaped", testSlashQuoteEscaped),
        ("testParametersEncoded", testParametersEncoded),
        ("testParametersDict", testParametersDict)
    ]
}
