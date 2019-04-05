//
//  Variables.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-04-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public struct GraphQLVariables: Encodable {
    var variables: [String: GraphQLVariable]
    
    public init(_ variables: [String: GraphQLVariable] = [:]) {
        self.variables = variables
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let wrappedDict = variables.compactMapValues(EncodableWrapper.init)
        try container.encode(wrappedDict)
    }
    
    public var statement: String {
        guard !variables.isEmpty else { return "" }
        let variableEncoded = variables
            .map { "$\($0.key): \($0.value.type)" }
            .sorted()
            .joined(separator: ", ")
        
        return "(\(variableEncoded))"
    }
    
    public static func +(lhs: GraphQLVariables, rhs: GraphQLVariables) -> GraphQLVariables {
        let contents = lhs.variables.merging(rhs.variables) { (_, new) in new }
        return GraphQLVariables(contents)
    }
    
    public mutating func set(_ variables: [String: GraphQLVariable?]) {
        for variable in variables {
            self.set(key: variable.key, value: variable.value)
        }
    }
    
    public mutating func set(key: String, value: GraphQLVariable?) {
        self.variables[key] = value
    }
    
    public subscript(key: String) -> GraphQLVariable? {
        get {
            return self.variables[key]
        }
        set {
            self.variables[key] = newValue
        }
    }
    
    private struct EncodableWrapper: Encodable {
        let value: Encodable?
        let defaultValue: Encodable?
        
        init?(_ variable: GraphQLVariable) {
            if variable.value == nil && variable.defaultValue == nil { return nil }
            self.value = variable.value
            self.defaultValue = variable.defaultValue
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try (value ?? defaultValue)?.encode(to: &container)
        }
    }
}
