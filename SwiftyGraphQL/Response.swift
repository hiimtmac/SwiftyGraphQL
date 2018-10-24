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
public struct GraphQLResponse<T>: Decodable where T: GraphQLDecodeable {
    public let data: T
    public let errors: [String]?
    
    public init(data: T, errors: [String]?) {
        self.data = data
        self.errors = errors
    }
}

/// All graphql responses come back wrapped in a `data` object
/// in json with an additional array of errors.
public struct GraphQLResponseCustomErrorType<T, U>: GraphQLDecodeable where T: Decodable, U: Decodable {
    public let data: T
    public let errors: U?
}
