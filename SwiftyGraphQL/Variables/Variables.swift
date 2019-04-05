//
//  Variables.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-04-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public struct GraphQLVariables: Encodable {
    var variables: [String: GraphQLVariableRepresentable]
    
    public init(_ variables: [String: GraphQLVariableRepresentable] = [:]) {
        self.variables = variables
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let wrappedDict = variables.mapValues(EncodableWrapper.init)
        try container.encode(wrappedDict)
    }
    
    public var statement: String {
        guard !variables.isEmpty else { return "" }
        let variableEncoded = variables
            .map { "$\($0.key): \(type(of: $0.value).variableType)" }
            .sorted()
            .joined(separator: ", ")
        
        return "(\(variableEncoded))"
    }
    
    public static func +(lhs: GraphQLVariables, rhs: GraphQLVariables) -> GraphQLVariables {
        let contents = lhs.variables.merging(rhs.variables) { (_, new) in new }
        return GraphQLVariables(contents)
    }
    
    public mutating func set(_ variables: [String: GraphQLVariableRepresentable?]) {
        for variable in variables {
            self.set(key: variable.key, value: variable.value)
        }
    }
    
    public mutating func set(key: String, value: GraphQLVariableRepresentable?) {
        self.variables[key] = value
    }
    
    public subscript(key: String) -> GraphQLVariableRepresentable? {
        get {
            return self.variables[key]
        }
        set {
            self.variables[key] = newValue
        }
    }
    
    private struct EncodableWrapper: Encodable {
        let wrapped: Encodable
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try self.wrapped.encode(to: &container)
        }
    }
}
