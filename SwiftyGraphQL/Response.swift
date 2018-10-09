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
public struct GraphQLResponse<T>: Decodable where T: Decodable {
    public let data: T
    public let errors: [String]?
}

/// All graphql responses come back wrapped in a `data` object
/// in json with an additional array of errors.
public struct GraphQLResponseCustomErrorType<T, U>: Decodable where T: Decodable, U: Decodable {
    public let data: T
    public let errors: U?
}
