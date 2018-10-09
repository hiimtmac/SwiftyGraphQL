//
//  Mutation.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import Foundation

/// Helper object to create a graphql mutation
/// for URLSession and specify expected return
public struct GraphQLMutation: Encodable {
    public let query: GraphQLStatement
    
    public init(mutation: GraphQLStatement, returning: GraphQLRepresentable) {
        self.query = "mutation { \(mutation) { \(returning.rawQuery) } } \(returning.fragments)"
    }
}
