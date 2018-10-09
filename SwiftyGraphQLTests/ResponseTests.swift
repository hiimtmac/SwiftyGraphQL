//
//  ResponseTests.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import XCTest
@testable import SwiftyGraphQL

class ResponseTests: XCTestCase {

    func testRegularObject() throws {
        let json =  """
        {
            "data": [
                "hi",
                "hello"
            ],
            "errors": [
                "something bad",
                "another bad thing"
            ]
        }
        """
        
        let data = json.data(using: .utf8)!
        
        let response = try JSONDecoder().decode(GraphQLResponse<[String]>.self, from: data)
        XCTAssertEqual(response.data.count, 2)
        XCTAssertEqual(response.errors?.count, 2)
    }
    
    func testCustomObject() throws {
        let json = """
        {
            "data": [
                {
                    "name": "taylor",
                    "age": 666
                }
            ],
            "errors": [
                {
                    "code": 666,
                    "name": "fatal error occurred"
                }
            ]
        }
        """
        
        struct ErrorType: Decodable {
            let code: Int
            let name: String
        }
        
        struct ObjectType: Decodable {
            let name: String
            let age: Int
        }
        
        let data = json.data(using: .utf8)!
        
        let response = try JSONDecoder().decode(GraphQLResponseCustomErrorType<[ObjectType], [ErrorType]>.self, from: data)
        XCTAssertEqual(response.data.count, 1)
        XCTAssertEqual(response.data.first?.name, "taylor")
        XCTAssertEqual(response.data.first?.age, 666)
        
        XCTAssertEqual(response.errors?.count, 1)
        XCTAssertEqual(response.errors?.first?.code, 666)
        XCTAssertEqual(response.errors?.first?.name, "fatal error occurred")
    }
}
