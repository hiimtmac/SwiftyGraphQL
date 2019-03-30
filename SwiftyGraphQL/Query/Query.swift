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
    
    public init(mutation: GraphQLStatement, returning: GraphQLRepresentable) {
        self.query = "mutation { \(mutation) { \(returning.rawQuery) } } \(returning.fragments)"
    }
    
    public init(mutation: GraphQLMutation, returning: GraphQLRepresentable) {
        self.query = "mutation { \(mutation.statement) { \(returning.rawQuery) } } \(returning.fragments)"
    }
}

public struct GraphQLMutation {
    let title: String
    let parameters: GraphQLParameters
    
    public init(title: String, parameters: GraphQLParameters) {
        self.title = title
        self.parameters = parameters
    }
    
    public var statement: GraphQLStatement {
        return "\(title)\(parameters.statement)"
    }
}
