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
    public let variables: GraphQLVariables?
    public let operationName: String?
    
    public init(returning: GraphQLRepresentable, variables: GraphQLVariables? = nil, operationName: String? = nil) {
        self.query = "query\(variables?.statement ?? "") { \(returning.rawQuery) } \(returning.fragments)"
        self.operationName = operationName
        self.variables = variables
    }
    
    public init(mutation: GraphQLMutation, returning: GraphQLRepresentable, variables: GraphQLVariables? = nil, operationName: String? = nil) {
        self.query = "mutation\(variables?.statement ?? "") { \(mutation.statement) { \(returning.rawQuery) } } \(returning.fragments)"
        self.operationName = operationName
        self.variables = variables
    }
}

public struct GraphQLMutation {
    let title: String
    let parameters: GraphQLParameters
    
    public init(title: String, parameters: GraphQLParameters) {
        self.title = title
        self.parameters = parameters
    }
    
    public init(title: String, parameters: [String: GraphQLArgument?]) {
        self.title = title
        self.parameters = GraphQLParameters(parameters)
    }
    
    public var statement: String {
        return "\(title)\(parameters.statement)"
    }
}
