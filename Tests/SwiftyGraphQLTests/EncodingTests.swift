// EncodingTests.swift
// Copyright © 2022 hiimtmac

import XCTest
@testable import SwiftyGraphQL

class EncodingTests: XCTestCase {
    func testVariableEncoding() throws {
        struct Variables: Decodable, Equatable {
            let name: String
            let age: Int
            let optional: String?
            let array: [Int]
        }

        let name = GQLVariable(name: "name", value: "tmac")
        let age = GQLVariable(name: "age", value: 29)
        let optional = GQLVariable(name: "optional", value: nil as String?)
        let array = GQLVariable(name: "array", value: [6, 6, 6])

        let query = GQL {
            "hi"
        }
        .withVariable(name)
        .withVariable(age)
        .withVariable(optional)
        .withVariable(array)

        let data = try JSONEncoder().encode(query)
        let decoded = try JSONDecoder().decode(TestEncoded<Variables>.self, from: data)
        XCTAssertEqual(decoded, TestEncoded<Variables>(query: "query($age: Int!, $array: [Int!]!, $name: String!, $optional: String) { hi }", variables: .init(name: "tmac", age: 29, optional: nil, array: [6, 6, 6])))
    }

    func testCustomVariableEncoding() throws {
        struct Custom: GraphQLVariableExpression, Decodable, Equatable {
            let name: String
        }

        struct Variables: Decodable, Equatable {
            let custom: Custom
        }

        let custom = GQLVariable(name: "custom", value: Custom(name: "tmac"))

        let query = GQL {
            "hi"
        }
        .withVariable(custom)

        let data = try JSONEncoder().encode(query)
        let decoded = try JSONDecoder().decode(TestEncoded<Variables>.self, from: data)
        XCTAssertEqual(decoded, TestEncoded<Variables>(query: "query($custom: Custom!) { hi }", variables: .init(custom: .init(name: "tmac"))))
    }

    static var allTests = [
        ("testVariableEncoding", testVariableEncoding),
        ("testCustomVariableEncoding", testCustomVariableEncoding),
    ]
}
