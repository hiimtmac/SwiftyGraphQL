//
//  Response.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import Foundation

/// All graphql responses come back wrapped in a `data` object
/// in json with an additional array of errors.
public struct GraphQLResponse<T> {
    public let data: T
    public let errors: [GraphQLError]?
    
    public init(data: T, errors: [GraphQLError]?) {
        self.data = data
        self.errors = errors
    }
    
    public var error: GraphQLErrors? {
        return GraphQLErrors(errors: errors)
    }
}

extension GraphQLResponse: Decodable where T: Decodable {}
extension GraphQLResponse: Encodable where T: Encodable {}
