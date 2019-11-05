//
//  Variables.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-04-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public struct GraphQLVariables {
    var storage: Set<GraphQLVariable>
    
    init(_ storage: Set<GraphQLVariable>) {
        self.storage = storage
    }
    
    public init(_ variables: [GraphQLVariable] = []) {
        self.storage = Set(variables)
    }
    
    public var statement: String {
        guard !storage.isEmpty else { return "" }
        let variableEncoded = storage
            .map { "$\($0.name): \($0.value.variableType)" }
            .sorted()
            .joined(separator: ", ")
        
        return "(\(variableEncoded))"
    }
    
    public static func +(lhs: GraphQLVariables, rhs: GraphQLVariables) -> GraphQLVariables {
        let contents = (lhs.storage.subtracting(rhs.storage).union(rhs.storage))
        return GraphQLVariables(contents)
    }
    
    public mutating func add(value: GraphQLVariable) {
        self.storage.insert(value)
    }
    
    public subscript(key: String) -> GraphQLVariable? {
        return self.storage.first { $0.name == key }
    }
}

extension GraphQLVariables: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: GraphQLVariable...) {
        self.storage = Set(elements)
    }
}

extension GraphQLVariables: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let sequence = storage.map { ($0.name, $0.value) }
        let wrappedDict = Dictionary
            .init(uniqueKeysWithValues: sequence)
            .compactMapValues(EncodableWrapper.init)
        try container.encode(wrappedDict)
    }
    
    private struct EncodableWrapper: Encodable {
        let storage: Encodable
        
        init(_ variable: GraphQLVariableRepresentable) {
            self.storage = variable
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try storage.encode(to: &container)
        }
    }
}
