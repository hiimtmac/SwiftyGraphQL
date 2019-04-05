//
//  Network.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2019-04-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation
import SwiftyGraphQL

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
    
    func perform<T, U>(headers: [String: String],
                       request: T, decoder: JSONDecoder? = nil,
                       completion: @escaping (Result<GraphQLResponse<U>, Error>) -> Void) where T: GraphQLRequest, U == T.GraphQLReturn {
        
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
