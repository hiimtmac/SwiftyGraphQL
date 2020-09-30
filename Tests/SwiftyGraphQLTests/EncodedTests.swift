//
//  File.swift
//  
//
//  Created by Taylor McIntyre on 2020-09-30.
//

import XCTest
@testable import SwiftyGraphQL

class EncodedTests: XCTestCase {
    
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
        
        let encoded = GQLEncoded(query: "hi", variables: [name, age, optional, array])
        let data = try JSONEncoder().encode(encoded)
        let decoded = try JSONDecoder().decode(TestEncoded<Variables>.self, from: data)
        XCTAssertEqual(decoded, TestEncoded<Variables>(query: "hi", variables: .init(name: "tmac", age: 29, optional: nil, array: [6, 6, 6])))
    }
    
    func testCustomVariableEncoding() throws {
        struct Custom: GraphQLVariableExpression, Decodable, Equatable {
            let name: String
        }
        
        struct Variables: Decodable, Equatable {
            let custom: Custom
        }
        
        let custom = GQLVariable(name: "custom", value: Custom(name: "tmac"))
        
        let encoded = GQLEncoded(query: "hi", variables: [custom])
        let data = try JSONEncoder().encode(encoded)
        let decoded = try JSONDecoder().decode(TestEncoded<Variables>.self, from: data)
        XCTAssertEqual(decoded, TestEncoded<Variables>(query: "hi", variables: .init(custom: .init(name: "tmac"))))
    }
    
    static var allTests = [
        ("testVariableEncoding", testVariableEncoding),
        ("testCustomVariableEncoding", testCustomVariableEncoding)
    ]
}
