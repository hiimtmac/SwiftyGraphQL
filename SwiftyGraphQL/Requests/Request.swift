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
    var requestHeaders: [String: String?]? { get set }
}

extension GraphQLRequest {
    public func urlRequest(headers flightHeaders: [String: String?]? = nil, encoder: JSONEncoder? = nil) throws -> URLRequest {
        let encoder = encoder ?? SwiftyGraphQL.shared.queryEncoder ?? JSONEncoder()
        
        guard let url = SwiftyGraphQL.shared.graphQLEndpoint else {
            fatalError("No url configured, please set `SwiftyGraphQL.shared.graphQLEndpoint`")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try encoder.encode(query)
        
        let dHeaders = SwiftyGraphQL.shared.defaultHeaders ?? [:]
        let rHeaders = requestHeaders ?? [:]
        let fHeaders = flightHeaders ?? [:]
        
        (dHeaders + rHeaders + fHeaders).forEach {
            if let value = $0.value {
                request.setValue(value, forHTTPHeaderField: $0.key)
            }
        }

        return request
    }
    
    public func decode(data: Data, decoder: JSONDecoder? = nil) throws -> GraphQLResponse<GraphQLReturn> {
        let decoder = decoder ?? SwiftyGraphQL.shared.responseDecoder ?? JSONDecoder()
        return try decoder.graphQLDecode(GraphQLResponse<GraphQLReturn>.self, from: data)
    }
}

extension Dictionary where Key == String, Value == String? {
    static func +(lhs: Self, rhs: Self) -> Self {
        return lhs.merging(rhs) { $1 }
    }
}
