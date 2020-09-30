//
//  ResponseTests.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import XCTest
@testable import SwiftyGraphQL

class GraphQLDecodeTests: XCTestCase {
    
    func testNoErrors() throws {
        let obj = TestRequest(
            data: ["hello", "hi"],
            errors: nil
        )
        
        let data = try JSONEncoder().encode(obj)
        
        let response = try JSONDecoder().graphQLDecode(GQLResponse<[String]>.self, from: data)
        XCTAssertEqual(response.data.count, 2)
        XCTAssertNil(response.errors)
        XCTAssertNil(response.error)
    }
    
    func testSucceedsWithErrors() throws {
        let obj = TestRequest(
            data: ["hello", "hi"],
            errors: [
                TestRequest.TestError(message: "wow bad"),
                TestRequest.TestError(message: "so bad")
            ]
        )
        
        let data = try JSONEncoder().encode(obj)
        
        let response = try JSONDecoder().graphQLDecode(GQLResponse<[String]>.self, from: data)
        XCTAssertEqual(response.data.count, 2)
        XCTAssertEqual(response.errors?.count, 2)
        XCTAssertEqual(response.error?.errors.count, 2)
    }
    
    func testFails() throws {
        let obj = TestRequest<[String]>(
            data: nil,
            errors: [
                TestRequest.TestError(message: "wow bad"),
                TestRequest.TestError(message: "so bad")
            ]
        )
        
        let data = try JSONEncoder().encode(obj)
        
        print(String(data: data, encoding: .utf8)!)
        
        do {
            let _ = try JSONDecoder().graphQLDecode(GQLResponse<[String]>.self, from: data)
            XCTFail("should not continue")
        } catch {
            guard let error = error as? GQLErrorSet else {
                XCTFail("wrong error")
                return
            }
            
            XCTAssertEqual(error.errors.count, 2)
        }
    }
    
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
            XCTAssertNil(error as? GQLError)
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
            let decodeError = error as? GQLErrorSet
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
            let decodeError = error as? GQLErrorSet
            XCTAssertEqual(decodeError?.localizedDescription, "Multiple unrecoverable GraphQL© queries/mutations")
        }
    }
    
    static var allTests = [
        ("testNoErrors", testNoErrors),
        ("testSucceedsWithErrors", testSucceedsWithErrors),
        ("testFails", testFails),
        ("testDecodesNormally", testDecodesNormally),
        ("testDecodesGraphQLDecodeableNormal", testDecodesGraphQLDecodeableNormal),
        ("testDecodesGraphQLDecodeableGraphable", testDecodesGraphQLDecodeableGraphable),
        ("testDecodeFailsNormal", testDecodeFailsNormal),
        ("testDecodeFailsGraphQLDecodeable", testDecodeFailsGraphQLDecodeable),
        ("testDecodeFailsGraphQLDecodeableMultiple", testDecodeFailsGraphQLDecodeableMultiple)
    ]
}
