//
//  ParameterTests.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2018-10-24.
//  Copyright © 2018 hiimtmac. All rights reserved.
//

import XCTest
import SwiftyGraphQL

class ArgumentTests: BaseTestCase {
    
    func testStringEncoding() {
        let val = GQLArgument(name: "string", value: "hello")
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, #"string: "hello""#)
    }
    
    func testIntEncoding() {
        let val = GQLArgument(name: "int", value: 8)
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, "int: 8")
    }
    
    func testFloatEncoding() {
        let val = GQLArgument(name: "float", value: 8.8)
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, "float: 8.8")
    }
    
    func testBoolEncoding() {
        let val = GQLArgument(name: "bool", value: true)
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, "bool: true")
    }
    
    func testArrayStringEncoding() {
        let val = GQLArgument(name: "array", value: ["6", "6"])
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, #"array: ["6", "6"]"#)
    }
    
    func testArrayIntEncoding() {
        let val = GQLArgument(name: "array", value: [6, 6])
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, "array: [6, 6]")
    }
    
    func testOptionalEncoding() {
        let val = GQLArgument(name: "optional", value: nil as Int?)
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, "optional: null")
    }
    
    func testVariableEncoding() {
        let val = GQLArgument(name: "variable", value: GQLVariable(name: "message", value: "hello"))
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, "variable: $message")
    }
    
//    func testParameters() {
//        let node = GQLNode("test")
//            .withArgument(named: "since", value: 20)
//            .withArgument(named: "name", value: "taylor")
//            .withArgument(named: "true", value: true)
//
//        XCTAssertEqual(node.gqlQueryString, #"test(name: "taylor", since: 20, true: true)"#)
//    }
//
//    func testParameterOverride() {
//        let node = GQLNode("test")
//            .withArgument(named: "since", value: 20)
//            .withArgument(named: "name", value: "taylor")
//            .withArgument(named: "since", value: nil as Int?)
//            .withArgument(named: "ok", value: true)
//            .withArgument(named: "name", value: "difficult")
//
//        XCTAssertEqual(node.gqlQueryString, #"test(name: "difficult", ok: true)"#)
//    }

//    func testParametersEncoded() {
//        let val1 = #"thing"thing"#
//        let val2 = #"thing\thing"#
//        let val3 = #"thing\"thing"#
//
//        let node = GQLNode("test")
//            .withArgument(named: "since", value: val1)
//            .withArgument(named: "ok", value: val2)
//            .withArgument(named: "yes", value: val3)
//            .withArgument(named: "sure", value: 4)
//            .withArgument(named: "normal", value: "also")
//
//        XCTAssertEqual(node.gqlQueryString, #"test(normal: "also", ok: "thing\\thing", since: "thing\"thing", sure: 4, yes: "thing\\\"thing")"#)
//    }
    
//    func testParametersDict() {
//        let val1 = #"thing"thing"#
//        let val2 = #"thing\thing"#
//        let val3 = #"thing\"thing"#
//
//        let node = GQLNode("test")
//            .withArgument(named: "since", value: val1)
//            .withArguments(["ok": val2, "yes": val3, "sure": 4])
//            .withArgument(named: "normal", value: "also")
//
//        XCTAssertEqual(node.gqlQueryString, #"test(normal: "also", ok: "thing\\thing", since: "thing\"thing", sure: 4, yes: "thing\\\"thing")"#)
//    }

    static var allTests = [
        ("testStringEncoding", testStringEncoding),
        ("testIntEncoding", testIntEncoding),
        ("testFloatEncoding", testFloatEncoding),
        ("testBoolEncoding", testBoolEncoding),
        ("testArrayIntEncoding", testArrayIntEncoding),
        ("testArrayStringEncoding", testArrayStringEncoding),
        ("testOptionalEncoding", testOptionalEncoding),
        ("testVariableEncoding", testVariableEncoding)
    ]
}
