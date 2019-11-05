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
    
    enum QueryType: String {
        case query
        case mutation
    }
    
    init(type: QueryType, returning: GraphQLRepresentable, variables: GraphQLVariables?, operationName: String?) {
        let fragments = returning.fragments
        let adaptedFragments = fragments == "" ? "" : " \(fragments)"
        let adaptedVariables = variables?.statement ?? ""
        
        if let operationName = operationName {
            self.query = "\(type.rawValue) \(operationName)\(adaptedVariables) { \(returning.rawQuery) }\(adaptedFragments)"
        } else {
            self.query = "\(type.rawValue)\(adaptedVariables) { \(returning.rawQuery) }\(adaptedFragments)"
        }
        self.variables = variables
    }
    
    public init(query: GraphQLRepresentable, variables: GraphQLVariables? = nil, operationName: String? = nil) {
//        var fragments = query.fragments
//        if fragments != "" {
//            fragments = " \(fragments)"
//        }
//
//        if let operationName = operationName {
//            self.query = "query \(operationName)\(variables?.statement ?? "") { \(query.rawQuery) }\(fragments)"
//        } else {
//            self.query = "query\(variables?.statement ?? "") { \(query.rawQuery) }\(fragments)"
//        }
//        self.variables = variables
        self.init(type: .query, returning: query, variables: variables, operationName: operationName)
    }
    
    public init(mutation: GraphQLRepresentable, variables: GraphQLVariables? = nil, operationName: String? = nil) {
//        var fragments = mutation.fragments
//        if fragments != "" {
//            fragments = " \(fragments)"
//        }
//
//        if let operationName = operationName {
//            self.query = "mutation \(operationName)\(variables?.statement ?? "") { \(mutation.statement) { \(returning.rawQuery) } }\(fragments)"
//        } else {
//            self.query = "mutation\(variables?.statement ?? "") { \(mutation.statement) { \(returning.rawQuery) } }\(fragments)"
//        }
//        self.variables = variables
        
        self.init(type: .mutation, returning: mutation, variables: variables, operationName: operationName)
    }
}
//
//public struct GraphQLMutation {
//    let title: String
//    let arguments: GraphQLArguments
//
//    public init(title: String, arguments: GraphQLArguments = .init()) {
//        self.title = title
//        self.arguments = arguments
//    }
//
//    public var statement: String {
//        return "\(title)\(arguments.statement)"
//    }
//}
