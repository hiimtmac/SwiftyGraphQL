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
    
    var network: MockNetwork!
    var request: TestRequest!
    
    override func setUp() {
        super.setUp()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        network = MockNetwork(session: session)
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "graphql.com"
        components.path = "/graphql"
        
        let node = GraphQLNode.node(nil, "me", nil, [.fragment(Frag2.self)])
        let query = GraphQLQuery(returning: node)
        request = TestRequest(query: query, headers: ["Content-Type":"application/json"])
        
        SwiftyGraphQL.shared.graphQLEndpoint = components.url!
    }
    
    struct TestRequest: GraphQLRequest {
        typealias GraphQLReturn = Frag2
        var query: GraphQLQuery
        var headers: [String: String]?
    }
    
    func testRequestCreation() throws {
        let urlRequest = try request.urlRequest()
        
        XCTAssertEqual(urlRequest.url?.absoluteString, "https://graphql.com/graphql")
        XCTAssertEqual(urlRequest.httpMethod, "POST")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Content-Type"], "application/json")
        
        let compare = #"{"query":"{ me: me { ...frag2 } } fragment frag2 on Frag2 { address birthday }"}"#
        
        guard let data = urlRequest.httpBody, let string = String(data: data, encoding: .utf8) else {
            XCTFail("no/bad data")
            return
        }
        
        XCTAssertEqual(string, compare)
    }
    
    func testRequestDefaultDecoder() {
        let exp = expectation(description: "network")
        
        let date = DateComponents(calendar: .current, year: 2019, month: 1, day: 1).date!

        let data = """
        {
            "data": {
                "address": "hiimtmac",
                "birth":568011600
            }
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), data)
        }
        
        network.perform(headers: [:], request: request) { result in
            switch result {
            case .success(let decoded):
                XCTAssertEqual(decoded.data.address, "hiimtmac")
                XCTAssertEqual(decoded.data.birthday.timeIntervalSince1970, date.timeIntervalSince1970)
            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func testRequestCustomDecoder() {
        let exp = expectation(description: "network")
        
        let date = DateComponents(calendar: .current, year: 2019, month: 1, day: 1).date!
        
        let data = """
        {
            "data": {
                "name":"hiimtmac",
                "age":27,
                "birth":"2019-01-01T05:00:00Z"
            }
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), data)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        network.perform(headers: [:], request: request, decoder: decoder) { result in
            switch result {
            case .success(let decoded):
                XCTAssertEqual(decoded.data.address, "hiimtmac")
                XCTAssertEqual(decoded.data.birthday.timeIntervalSince1970, date.timeIntervalSince1970)
            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func testRequestGraphQLError() {
        let exp = expectation(description: "network")
        
        let data = """
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
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), data)
        }
        
        network.perform(headers: [:], request: request) { result in
            switch result {
            case .success:
                XCTFail("should not succeed")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (SwiftyGraphQLTests.MockError error 2.)")
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}
