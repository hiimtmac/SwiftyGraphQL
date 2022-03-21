// ArgumentTests.swift
// Copyright © 2022 hiimtmac

import SwiftyGraphQL
import XCTest

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

    static var allTests = [
        ("testStringEncoding", testStringEncoding),
        ("testIntEncoding", testIntEncoding),
        ("testFloatEncoding", testFloatEncoding),
        ("testBoolEncoding", testBoolEncoding),
        ("testArrayIntEncoding", testArrayIntEncoding),
        ("testArrayStringEncoding", testArrayStringEncoding),
        ("testOptionalEncoding", testOptionalEncoding),
        ("testVariableEncoding", testVariableEncoding),
    ]
}
