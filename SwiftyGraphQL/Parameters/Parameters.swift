//
//  Parameters.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-24.
//  Copyright © 2018 hiimtmac. All rights reserved.
//

import Foundation

public struct GraphQLParameters {
    var parameters: [String: GraphQLParameterRepresentable?]
    
    public init(_ parameters: [String: GraphQLParameterRepresentable?] = [:]) {
        self.parameters = parameters
    }
    
    public var statement: String {
        guard !parameters.isEmpty else { return "" }
        let parametersEncoded = parameters
            .map { "\($0.key): \($0.value.parameterValue)" }
            .sorted()
            .joined(separator: ", ")
        
        return "(\(parametersEncoded))"
    }
    
    public static func +(lhs: GraphQLParameters, rhs: GraphQLParameters) -> GraphQLParameters {
        let contents = lhs.parameters.merging(rhs.parameters) { (_, new) in new }
        return GraphQLParameters(contents)
    }
    
    public mutating func set(_ parameters: [String: GraphQLParameterRepresentable?]) {
        for parameter in parameters {
            self.set(key: parameter.key, value: parameter.value)
        }
    }
    
    public mutating func set(key: String, value: GraphQLParameterRepresentable?) {
        self.parameters[key] = value
    }
    
    public subscript(key: String) -> GraphQLParameterRepresentable? {
        get {
            return self.parameters[key]
        }
        set {
            self.parameters[key] = newValue
        }
    }
}

extension GraphQLParameters: GraphQLParameterRepresentable {
    public var parameterValue: String {
        let parametersEncoded = parameters
            .map { "\($0.key): \($0.value.parameterValue)" }
            .sorted()
            .joined(separator: ", ")
        
        return "{ \(parametersEncoded) }"
    }
}
