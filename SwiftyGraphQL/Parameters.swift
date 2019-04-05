//
//  Parameters.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-24.
//  Copyright © 2018 hiimtmac. All rights reserved.
//

import Foundation

public struct GraphQLParameters {
    var parameters: [String: GraphQLArgument?]
    
    public init(_ parameters: [String: GraphQLArgument?] = [:]) {
        self.parameters = parameters
    }
    
    public var statement: String {
        guard !parameters.isEmpty else { return "" }
        let parametersEncoded = parameters
            .map { "\($0.key): \($0.value.graphQLEncoded())" }
            .sorted()
            .joined(separator: ", ")
        
        return "(\(parametersEncoded))"
    }
    
    public static func +(lhs: GraphQLParameters, rhs: GraphQLParameters) -> GraphQLParameters {
        let contents = lhs.parameters.merging(rhs.parameters) { (_, new) in new }
        return GraphQLParameters(contents)
    }
    
    public mutating func set(_ parameters: [String: GraphQLArgument?]) {
        for parameter in parameters {
            self.set(key: parameter.key, value: parameter.value)
        }
    }
    
    public mutating func set(key: String, value: GraphQLArgument?) {
        self.parameters[key] = value
    }
    
    public subscript(key: String) -> GraphQLArgument? {
        get {
            return self.parameters[key]
        }
        set {
            self.parameters[key] = newValue
        }
    }
}

extension GraphQLParameters: GraphQLArgument {
    public func graphQLEncoded() -> String {
        let parametersEncoded = parameters
            .map { "\($0.key): \($0.value.graphQLEncoded())" }
            .sorted()
            .joined(separator: ", ")
        
        return "{ \(parametersEncoded) }"
    }
}
