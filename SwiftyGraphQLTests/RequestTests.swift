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
    var request: TestGraphRequest!
    
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
        request = TestGraphRequest(query: query, requestHeaders: ["Accept":"application/json", "Content-Type":"application/json"])
        
        SwiftyGraphQL.shared.graphQLEndpoint = components.url!
    }
    
    struct TestGraphRequest: GraphQLRequest {
        typealias GraphQLReturn = Frag2
        var query: GraphQLQuery
        var requestHeaders: [String: String?]?
    }
    
    func testRequestCreation() throws {
        let urlRequest = try request.urlRequest()
        
        XCTAssertEqual(urlRequest.url?.absoluteString, "https://graphql.com/graphql")
        XCTAssertEqual(urlRequest.httpMethod, "POST")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Content-Type"], "application/json")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Accept"], "application/json")
        
        let compare = #"{"query":"query { me: me { ...frag2 } } fragment frag2 on Frag2 { address birthday }"}"#
        
        guard let data = urlRequest.httpBody, let string = String(data: data, encoding: .utf8) else {
            XCTFail("no/bad data")
            return
        }
        
        XCTAssertEqual(string, compare)
    }
    
    func testRequestHeaders() throws {
        struct HeaderRequest: GraphQLRequest {
            typealias GraphQLReturn = String
            var query: GraphQLQuery
            var requestHeaders: [String : String?]?
        }
        
        let query = GraphQLQuery(returning: GraphQLNode.node(nil, "hi", nil, [.attributes(["hi"])]))
        
        SwiftyGraphQL.shared.defaultHeaders = ["one":"default", "two":"default", "three":"default", "four":"default", "five":"default"]
        let request = HeaderRequest(query: query, requestHeaders: ["one":nil, "two":"request", "three":"request", "four":"request", "six":"request"])
        let urlRequest = try request.urlRequest(headers: ["three":"flight", "four": nil, "seven":"flight"])
        
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["one"], nil)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["two"], "request")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["three"], "flight")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["four"], nil)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["five"], "default")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["six"], "request")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["seven"], "flight")
    }
    
    func testRequestDefaultDecoder() throws {
        let exp = expectation(description: "network")
        
        let date = Date()
        let obj = TestRequest(data: Frag2(birthday: date, address: "place"), errors: nil)
        let data = try JSONEncoder().encode(obj)
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), data)
        }
        
        network.perform(headers: [:], request: request) { result in
            switch result {
            case .success(let decoded):
                XCTAssertEqual(decoded.data.address, "place")
                XCTAssertEqual(decoded.data.birthday.timeIntervalSince1970, date.timeIntervalSince1970)
            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func testRequestCustomDecoder() throws {
        let exp = expectation(description: "network")
        
        let date = Date()
        let obj = TestRequest(data: Frag2(birthday: date, address: "place"), errors: nil)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(obj)
        
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), data)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        network.perform(headers: [:], request: request, decoder: decoder) { result in
            switch result {
            case .success(let decoded):
                XCTAssertEqual(decoded.data.address, "place")
                XCTAssertEqual(Int(decoded.data.birthday.timeIntervalSince1970), Int(date.timeIntervalSince1970))
            case .failure(let error):
                print(error)
                XCTFail(error.localizedDescription)
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    func testRequestGraphQLError() throws {
        let exp = expectation(description: "network")
        
        let obj = TestRequest<String>(data: nil, errors: [TestRequest.TestError(message: "this is bad")])
        let data = try JSONEncoder().encode(obj)
        
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
