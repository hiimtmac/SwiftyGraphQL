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
public struct GQLResponse<T> {
    public let data: T
    public let errors: [GQLError]?
    
    public init(data: T, errors: [GQLError]?) {
        self.data = data
        self.errors = errors
    }
    
    public var error: GQLErrorSet? {
        return GQLErrorSet(errors: errors)
    }
}

extension GQLResponse: Decodable where T: Decodable {}
extension GQLResponse: Encodable where T: Encodable {}
