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
    public let query: String
    public let operationName: String?
//    public let variables: [String: GraphQLParameterEncodable?]?
    
    public init(returning: GraphQLRepresentable, operationName: String? = nil) {
        self.query = "{ \(returning.rawQuery) } \(returning.fragments)"
        self.operationName = operationName
    }
    
    public init(mutation: String, returning: GraphQLRepresentable, operationName: String? = nil) {
        self.query = "mutation { \(mutation) { \(returning.rawQuery) } } \(returning.fragments)"
        self.operationName = operationName
    }
    
    public init(mutation: GraphQLMutation, returning: GraphQLRepresentable, operationName: String? = nil) {
        self.query = "mutation { \(mutation.statement) { \(returning.rawQuery) } } \(returning.fragments)"
        self.operationName = operationName
    }
}

public struct GraphQLMutation {
    let title: String
    let parameters: GraphQLParameters
    
    public init(title: String, parameters: GraphQLParameters) {
        self.title = title
        self.parameters = parameters
    }
    
    public var statement: String {
        return "\(title)\(parameters.statement)"
    }
}
