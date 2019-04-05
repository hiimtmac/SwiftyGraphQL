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
    
    public init(_ variables: [GraphQLVariable] = []) {
        var dict = [String: GraphQLVariable]()
        for variable in variables {
            dict[variable.key] = variable
        }
        self.variables = dict
    }
    
    public init(_ variables: [String: GraphQLVariable] = [:]) {
        self.variables = variables
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode("variables.map { $0.value }")
    }
    
    public var statement: String {
        guard !variables.isEmpty else { return "" }
        let variableEncoded = variables
            .map { "$\($0.key): \($0.value.variableParameter)" }
            .sorted()
            .joined(separator: ", ")
        
        return "(\(variableEncoded))"
    }
    
    public static func +(lhs: GraphQLVariables, rhs: GraphQLVariables) -> GraphQLVariables {
        let contents = lhs.variables.merging(rhs.variables) { (_, new) in new }
        return GraphQLVariables(contents)
    }
    
    public mutating func set(_ variables: [GraphQLVariable]) {
        for variable in variables {
            self.set(key: variable.key, value: variable)
        }
    }
    
    public mutating func set(key: String, value: GraphQLVariable) {
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
}
