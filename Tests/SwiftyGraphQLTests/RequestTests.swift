//
//  RequestTests.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2019-03-29.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import XCTest
@testable import SwiftyGraphQL

#if canImport(ObjectiveC)
class RequestTests: XCTestCase {
    
    var network: MockNetwork!
    var request: GQLRequest<Frag2>!
    
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
        
        let query = GQL(.query) {
            GQLNode("me") {
                Frag2.asFragment()
            }
        }
        
        let headers = HTTPHeaders([HTTPHeader(name: .contentEncoding, value: .json)])
        request = GQLRequest(query: query, headers: headers)
        
        SwiftyGraphQL.shared.graphQLEndpoint = components.url!
    }
    
    func testRequestCreation() throws {
        let urlRequest = try request.urlRequest()
        
        XCTAssertEqual(urlRequest.url?.absoluteString, "https://graphql.com/graphql")
        XCTAssertEqual(urlRequest.httpMethod, "POST")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Content-Type"], "application/json; charset=utf-8")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Accept"], "application/json; charset=utf-8")
        
        let compare = #"{"query":"query { me { ...frag2 } } fragment frag2 on Frag2 { birthday address }"}"#
        
        guard let data = urlRequest.httpBody, let string = String(data: data, encoding: .utf8) else {
            XCTFail("no/bad data")
            return
        }
        
        XCTAssertEqual(string, compare)
    }
    
    func testRequestHeaders() throws {
        let query = GQL(.query) {
            GQLNode("hi") {
                "hi"
            }
        }
        
        SwiftyGraphQL.shared.defaultHeaders = HTTPHeaders([
            .init(name: .init("one"), value: "default"),
            .init(name: .init("two"), value: "default"),
            .init(name: .init("three"), value: "default"),
            .init(name: .init("four"), value: "default"),
            .init(name: .init("five"), value: "asdasd"),
            .init(name: .init("five"), value: "default")
        ])
        var request = GQLRequest<String>(query: query, headers: HTTPHeaders([
            .init(name: .init("one"), value: "nil"),
            .init(name: .init("two"), value: "request"),
            .init(name: .init("three"), value: "request"),
            .init(name: .init("four"), value: "request"),
            .init(name: .init("six"), value: "request")
        ]))
        request.addEncodePlugin { request in
            HTTPHeaders([
                .init(name: .init("three"), value: "flight"),
                .init(name: .init("seven"), value: "flight")
            ]).headers.forEach {
                request.setValue($0.value, forHTTPHeaderField: $0.key.name)
            }
            request.setValue(nil, forHTTPHeaderField: "four")
        }
        let urlRequest = try request.urlRequest()
        
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["one"], "nil")
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
        
        network.perform(request: request) { result in
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
        
        request.decoder = decoder
        
        network.perform(request: request) { result in
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
        
        network.perform(request: request) { result in
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
    
    func testCombineHeaders() {
        let one = HTTPHeaders([
            .init(name: .accept, value: "chaff"),
            .init(name: .accept, value: .json),
            .init(name: .contentEncoding, value: .any)
        ])
        
        let two = HTTPHeaders([
            .init(name: .contentType, value: .json),
            .init(name: .contentEncoding, value: .plainText)
        ])
        
        let combine = one + two
        XCTAssertEqual(combine.headers.count, 3)
        XCTAssertEqual(combine[.accept], "application/json; charset=utf-8")
        XCTAssertEqual(combine[.contentEncoding], "text/plain; charset=utf-8")
        XCTAssertEqual(combine[.contentType], "application/json; charset=utf-8")
    }
    
    func testRequestPlugins() throws {
        let query = GQL(.query) {
            GQLNode("hi") {
                "hi"
            }
        }
        var request = GQLRequest<String>(query: query)
        let urlReq = try request.urlRequest()
        XCTAssertEqual(urlReq.cachePolicy.rawValue, URLRequest.CachePolicy.useProtocolCachePolicy.rawValue)
        XCTAssertEqual(urlReq.timeoutInterval, 60)
        XCTAssertEqual(urlReq.httpMethod, "POST")
        
        request.encodePlugins = [
            { $0.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData },
            { $0.httpMethod = "GET" }
        ]
        
        let one = try request.urlRequest()
        XCTAssertEqual(one.cachePolicy.rawValue, URLRequest.CachePolicy.reloadIgnoringCacheData.rawValue)
        XCTAssertEqual(one.httpMethod, "GET")
        
        request.addEncodePlugin { $0.timeoutInterval = 50 }
        request.addEncodePlugin { $0.httpMethod = "PUT" }
        
        let two = try request.urlRequest()
        XCTAssertEqual(two.timeoutInterval, 50)
        XCTAssertEqual(two.httpMethod, "PUT")
    }
    
    static var allTests = [
        ("testRequestCreation", testRequestCreation),
        ("testRequestHeaders", testRequestHeaders),
        ("testRequestDefaultDecoder", testRequestDefaultDecoder),
        ("testRequestCustomDecoder", testRequestCustomDecoder),
        ("testRequestGraphQLError", testRequestGraphQLError),
        ("testCombineHeaders", testCombineHeaders),
        ("testRequestPlugins", testRequestPlugins)
    ]
}
#endif
