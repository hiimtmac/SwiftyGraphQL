//
//  Helpers.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import XCTest
import Foundation
import SwiftyGraphQL

struct Frag1: GraphQLFragmentRepresentable {
    let name: String
    let age: String
    
    static var entityName: String = "Fragment1"
    static var fragmentName: String = "fragment1"
    static var attributes: [String] = ["name", "age"]
}

struct Frag2: GraphQLFragmentRepresentable {
    let birthday: Date
    let address: String?
    
    static var attributes: [String] = ["birthday", "address"]
}

struct MockObject: GraphQLDecodable, GraphQLFragmentRepresentable, Equatable, Encodable {
    
    let name: String
    let age: Int
    let birth: Date

    static var attributes: [String] { return ["name", "age", "birthday"] }
}

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        //
    }
}

enum MockError: String, Error, Equatable {
    case noURL
    case noData
    case decodeError
}

class MockNetwork {
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func perform<T, U>(headers: [String: String], request: T, decoder: JSONDecoder? = nil, completion: @escaping (Result<U, Error>) -> Void) where T: GraphQLRequest, U == T.GraphQLReturn {
        guard let urlRequest = try? request.urlRequest(headers: headers) else {
            completion(.failure(MockError.noURL))
            return
        }
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                completion(Result.failure(MockError.noData))
                return
            }
            
            guard let decoded = try? request.decode(data: data, decoder: decoder) else {
                completion(Result.failure(MockError.decodeError))
                return
            }
            
            completion(Result.success(decoded))
        }.resume()
    }
}
