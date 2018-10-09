//
//  Query.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import Foundation

/// Helper object to create a graphql query
/// for URLSession
public struct GraphQLQuery: Encodable {
    public let query: GraphQLStatement
    
    public init(returning: GraphQLRepresentable) {
        self.query = "{ \(returning.rawQuery) } \(returning.fragments)"
    }
}
