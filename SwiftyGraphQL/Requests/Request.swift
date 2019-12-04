//
//  Request.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-03-29.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public struct GraphQLRequest<T: Decodable> {
    public let query: GraphQLQuery
    public var headers: HTTPHeaders
    public var encoder: JSONEncoder?
    public var encodePlugins: [(inout URLRequest) -> Void]
    public var decoder: JSONDecoder?
    
    public init(query: GraphQLQuery,
                headers: HTTPHeaders = .init(),
                encoder: JSONEncoder? = nil,
                encodePlugins: [(inout URLRequest) -> Void] = [],
                decoder: JSONDecoder? = nil) {
        self.query = query
        self.headers = headers
        self.encoder = encoder
        self.encodePlugins = encodePlugins
        self.decoder = decoder
    }
    
    public mutating func addEncodePlugin(_ plugin: @escaping (inout URLRequest) -> Void) {
        self.encodePlugins.append(plugin)
    }
}

extension GraphQLRequest {
    public func urlRequest() throws -> URLRequest {
        let encoder = self.encoder ?? SwiftyGraphQL.shared.queryEncoder
        
        guard let url = SwiftyGraphQL.shared.graphQLEndpoint else {
            fatalError("No url configured, please set `SwiftyGraphQL.shared.graphQLEndpoint`")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try encoder.encode(query)
        
        (SwiftyGraphQL.shared.defaultHeaders + self.headers).headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key.name)
        }
        
        encodePlugins.forEach { $0(&request) }

        return request
    }
    
    public func decode(data: Data) throws -> GraphQLResponse<T> {
        let decoder = self.decoder ?? SwiftyGraphQL.shared.responseDecoder
        return try decoder.graphQLDecode(GraphQLResponse<T>.self, from: data)
    }
}
