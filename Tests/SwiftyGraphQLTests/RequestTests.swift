//
//  RequestTests.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2019-03-29.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import XCTest
@testable import SwiftyGraphQL

class RequestTests: XCTestCase {
    
    func testRequestCreation() throws {
        let urlRequest = URLRequest.graphql(url: URL(string: "https://graphql.com/graphql")!)
        
        XCTAssertEqual(urlRequest.url?.absoluteString, "https://graphql.com/graphql")
        XCTAssertEqual(urlRequest.httpMethod, "POST")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Content-Type"], "application/json; charset=utf-8")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Accept"], "application/json; charset=utf-8")
    }
    
    func testRequestHeaders() throws {
        var urlRequest = URLRequest.graphql(url: URL(string: "https://graphql.com/graphql")!)
        
        urlRequest.add(HTTPHeader(.init("one"), value: "default"))
        urlRequest.set(HTTPHeader(.init("two"), value: "default"))
        urlRequest.add(HTTPHeader(.init("three"), value: "default"))
        urlRequest.set(HTTPHeader(.init("four"), value: "default"))
        
        urlRequest.add(HTTPHeader(.init("one"), value: "nil"))
        urlRequest.set(HTTPHeader(.init("two"), value: "request"))
        urlRequest.add(HTTPHeader(.init("three"), value: "request"))
        urlRequest.add(HTTPHeader(.init("four"), value: "request"))
        
        urlRequest.remove(.init("three"))
        urlRequest.set(HTTPHeader(.init("four"), value: "after"))
        
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["one"], "default,nil")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["two"], "request")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["three"], nil)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["four"], "after")
    }
    
    static var allTests = [
        ("testRequestCreation", testRequestCreation),
        ("testRequestHeaders", testRequestHeaders)
    ]
}
