//
//  GraphQLDecodeableTests.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2018-10-24.
//  Copyright © 2018 hiimtmac. All rights reserved.
//

import XCTest
@testable import SwiftyGraphQL

class GraphQLDecodeableTests: XCTestCase {

    struct TypeOne: Decodable {
        let name: String
    }
    
    struct TypeTwo: Decodable {
        let name: String
    }

    func testDecodesNormally() throws {
        let payload = ["name":"hiimtmac"]
        let data = try JSONSerialization.data(withJSONObject: payload, options: [])

        let decoded = try? JSONDecoder().decode(TypeOne.self, from: data)
        XCTAssertNotNil(decoded)
    }
    
    func testDecodesGraphQLDecodeableNormal() throws {
        let payload = ["name":"hiimtmac"]
        let data = try JSONSerialization.data(withJSONObject: payload, options: [])

        let decoded = try? JSONDecoder().decode(TypeTwo.self, from: data)
        XCTAssertNotNil(decoded)
    }
    
    func testDecodesGraphQLDecodeableGraphable() throws {
        let payload = ["name":"hiimtmac"]
        let data = try JSONSerialization.data(withJSONObject: payload, options: [])
        
        let decoded = try? JSONDecoder().graphQLDecode(TypeTwo.self, from: data)
        XCTAssertNotNil(decoded)
    }
    
    func testDecodeFailsNormal() throws {
        let payload = ["twitter":"hiimtmac"]
        let data = try JSONSerialization.data(withJSONObject: payload, options: [])
        
        do {
            let _ = try JSONDecoder().graphQLDecode(TypeTwo.self, from: data)
            XCTFail("should not work")
        } catch {
            XCTAssertNil(error as? GraphQLError)
            XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it is missing.")
        }
    }
    
    func testDecodeFailsGraphQLDecodeable() {
        let json = """
        {
            "errors": [
                {
                    "message": "this is bad",
                    "locations": [
                        {
                            "line": 4,
                            "column": 6
                        }
                    ],
                    "fields": [
                        "thing",
                        "other"
                    ]
                }
            ]
        }
        """
        let data = json.data(using: .utf8)!
        
        do {
            let _ = try JSONDecoder().graphQLDecode(TypeTwo.self, from: data)
            XCTFail("should not work")
        } catch {
            let decodeError = error as? GraphQLErrors
            XCTAssertEqual(decodeError?.localizedDescription, "Unrecoverable GraphQL© query/mutation: this is bad")
        }
    }
    
    func testDecodeFailsGraphQLDecodeableMultiple() {
        let json = """
        {
            "errors": [
                {
                    "message": "this is bad",
                    "locations": [
                        {
                            "line": 4,
                            "column": 6
                        }
                    ],
                    "fields": [
                        "thing",
                        "other"
                    ]
                },
                {
                    "message": "this is horrible",
                    "locations": [
                        {
                            "line": 6,
                            "column": 9
                        }
                    ],
                    "fields": [
                        "bad",
                        "other"
                    ]
                }
            ]
        }
        """
        let data = json.data(using: .utf8)!
        
        do {
            let _ = try JSONDecoder().graphQLDecode(TypeTwo.self, from: data)
            XCTFail("should not work")
        } catch {
            let decodeError = error as? GraphQLErrors
            XCTAssertEqual(decodeError?.localizedDescription, "Multiple unrecoverable GraphQL© queries/mutations")
        }
    }
}
