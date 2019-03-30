//
//  Request.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-03-29.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public protocol GraphQLRequest {
    associatedtype GraphQLReturn: GraphQLDecodable
    var query: GraphQLQuery { get set }
}

extension GraphQLRequest {
    public func urlRequest(encoder: JSONEncoder? = nil) throws -> URLRequest {
        let encoder = encoder ?? SwiftyGraphQL.shared.queryEncoder ?? JSONEncoder()
        
        guard let url = SwiftyGraphQL.shared.graphQLEndpoint else {
            fatalError("No url configured")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try encoder.encode(query)
        
        return request
    }
    
    public func decode(data: Data, decoder: JSONDecoder? = nil) throws -> GraphQLReturn {
        let decoder = decoder ?? SwiftyGraphQL.shared.responseDecoder ?? JSONDecoder()
        return try decoder.graphQLDecode(GraphQLReturn.self, from: data)
    }
}
