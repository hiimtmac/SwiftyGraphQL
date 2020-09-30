//
//  VariableTests.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2019-04-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import XCTest
import SwiftyGraphQL

class VariableTests: BaseTestCase {
    
    func testStringEncoding() {
        let val = GQLVariable(name: "string", value: "hello")
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, #"$string: String!"#)
    }
    
    func testIntEncoding() {
        let val = GQLVariable(name: "int", value: 8)
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, "$int: Int!")
    }
    
    func testFloatEncoding() {
        let val = GQLVariable(name: "float", value: 8.8)
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, "$float: Float!")
    }
    
    func testBoolEncoding() {
        let val = GQLVariable(name: "bool", value: true)
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, "$bool: Boolean!")
    }
    
    func testArrayStringEncoding() {
        let val = GQLVariable(name: "array", value: ["6", "6"])
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, #"$array: [String!]!"#)
    }
    
    func testArrayIntEncoding() {
        let val = GQLVariable(name: "array", value: [6, 6])
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, "$array: [Int!]!")
    }
    
    func testArrayOptionalEncoding() {
        let val = GQLVariable(name: "array", value: [6, 6] as [Int?])
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, "$array: [Int]!")
    }
    
    func testOptionalArrayOptionalEncoding() {
        let val = GQLVariable(name: "array", value: [6, 6] as [Int?]?)
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, "$array: [Int]")
    }
    
    func testOptionalEncoding() {
        let val = GQLVariable(name: "array", value: 6 as Int?)
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, "$array: Int")
    }
    
    func testCustomEncodableNameSynth() throws {
        struct Custom: GraphQLVariableExpression {
            let name: String
        }
        
        let val = GQLVariable(name: "custom", value: Custom(name: "tmac"))
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, "$custom: Custom!")
    }
    
    func testCustomOptional() throws {
        struct Custom: GraphQLVariableExpression {
            let name: String
        }
        
        let val = GQLVariable(name: "custom", value: Custom(name: "tmac") as Custom?)
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, "$custom: Custom")
    }
    
    func testCustomEncodableNameCustom() throws {
        struct Custom: GraphQLVariableExpression {
            static var gqlScalar: GQLScalar = .custom("CustomThing")
            let name: String
        }
        
        let val = GQLVariable(name: "custom", value: Custom(name: "tmac"))
        val.serialize(to: &serializer)
        XCTAssertEqual(graphQL, "$custom: CustomThing!")
    }
      
    static var allTests = [
        ("testStringEncoding", testStringEncoding),
        ("testIntEncoding", testIntEncoding),
        ("testFloatEncoding", testFloatEncoding),
        ("testBoolEncoding", testBoolEncoding),
        ("testArrayIntEncoding", testArrayIntEncoding),
        ("testArrayStringEncoding", testArrayStringEncoding),
        ("testArrayOptionalEncoding", testArrayOptionalEncoding),
        ("testOptionalEncoding", testOptionalEncoding),
        ("testOptionalArrayOptionalEncoding", testOptionalArrayOptionalEncoding),
        ("testCustomEncodableNameSynth", testCustomEncodableNameSynth),
        ("testCustomOptional", testCustomOptional),
        ("testCustomEncodableNameCustom", testCustomEncodableNameCustom)
    ]
}
