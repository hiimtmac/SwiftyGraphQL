//
//  Request.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-03-29.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public protocol GraphQLRequest {
    associatedtype GraphQLReturn: Decodable
    var query: GraphQLQuery { get set }
    var headers: [String: String]? { get set }
}

extension GraphQLRequest {
    public func urlRequest(headers: [String: String]? = nil, encoder: JSONEncoder? = nil) throws -> URLRequest {
        let encoder = encoder ?? SwiftyGraphQL.shared.queryEncoder ?? JSONEncoder()
        
        guard let url = SwiftyGraphQL.shared.graphQLEndpoint else {
            fatalError("No url configured")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try encoder.encode(query)
        
        for header in headers ?? self.headers ?? [:] {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }
    
    public func decode(data: Data, decoder: JSONDecoder? = nil) throws -> GraphQLResponse<GraphQLReturn> {
        let decoder = decoder ?? SwiftyGraphQL.shared.responseDecoder ?? JSONDecoder()
        return try decoder.graphQLDecode(GraphQLResponse<GraphQLReturn>.self, from: data)
    }
}
