// RequestTests.swift
// Copyright © 2022 hiimtmac

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

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

        let one = HTTPHeaderName("one")
        let two = HTTPHeaderName("two")
        let three = HTTPHeaderName("three")
        let four = HTTPHeaderName("four")
        
        urlRequest.add(HTTPHeader(one, value: "default"))
        urlRequest.set(HTTPHeader(two, value: "default"))
        urlRequest.add(HTTPHeader(three, value: "default"))
        urlRequest.set(HTTPHeader(four, value: "default"))

        urlRequest.add(HTTPHeader(one, value: "nil"))
        urlRequest.set(HTTPHeader(two, value: "request"))
        urlRequest.add(HTTPHeader(three, value: "request"))
        urlRequest.add(HTTPHeader(four, value: "request"))

        urlRequest.remove(three)
        urlRequest.set(HTTPHeader(four, value: "after"))

        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["one"], "default,nil")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["two"], "request")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["three"], nil)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["four"], "after")
    }

    static var allTests = [
        ("testRequestCreation", testRequestCreation),
        ("testRequestHeaders", testRequestHeaders),
    ]
}
