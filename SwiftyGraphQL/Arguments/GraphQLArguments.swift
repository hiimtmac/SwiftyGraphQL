//
//  Parameters.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-24.
//  Copyright © 2018 hiimtmac. All rights reserved.
//

import Foundation

public struct GraphQLArguments {
    var storage: [String: GraphQLArgument?]
    
    public init(_ arguments: [String: GraphQLArgument?] = [:]) {
        self.storage = arguments
    }
    
    public var statement: String {
        guard !storage.isEmpty else { return "" }
        let parametersEncoded = storage
            .map { "\($0.key): \($0.value.parameterValue)" }
            .sorted()
            .joined(separator: ", ")
        
        return "(\(parametersEncoded))"
    }
    
    public static func +(lhs: GraphQLArguments, rhs: GraphQLArguments) -> GraphQLArguments {
        let contents = lhs.storage.merging(rhs.storage) { $1 }
        return GraphQLArguments(contents)
    }
    
    public mutating func add(key: String, value: GraphQLArgument?) {
        self.storage[key] = value
    }
    
    public subscript(key: String) -> GraphQLArgument? {
        get {
            return self.storage[key]
        }
        set {
            self.storage[key] = newValue
        }
    }
}

extension GraphQLArguments: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, GraphQLArgument?)...) {
        self.storage = Dictionary.init(uniqueKeysWithValues: elements)
    }
}

extension GraphQLArguments: GraphQLArgument {
    public var parameterValue: String {
        let parametersEncoded = storage
            .map { "\($0.key): \($0.value.parameterValue)" }
            .sorted()
            .joined(separator: ", ")
        
        return "{ \(parametersEncoded) }"
    }
}
