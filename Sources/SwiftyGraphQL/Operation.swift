//
//  Operation.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2020-01-08.
//  Copyright © 2020 hiimtmac. All rights reserved.
//

import Foundation

public protocol GQLOperation: GraphQL, Encodable {
    static var operationType: String { get }
    var operationName: String? { get }
    var variables: [String: GQLVariable] { get }
    var content: GraphQL { get }
    func copy(withVariables: [String: GQLVariable]) -> Self
}

extension GQLOperation {
    public func withVariable<T: GQLVariable>(named: String, value: T) -> Self {
        var varCopy = variables
        varCopy[named] = value
        
        return copy(withVariables: varCopy)
    }
    
    public var gqlQueryString: String {
        var builder = Self.operationType
        
        if let operationName = operationName {
            builder += " \(operationName)"
        }
        
        if !variables.isEmpty {
            let vars = variables
                .map { "$\($0.key): \(type(of: $0.value).gqlVariableType)" }
                .sorted()
                .joined(separator: ", ")
            
            builder += "(\(vars))"
        }
        
        if !content.gqlQueryString.isEmpty {
            builder += " { \(content.gqlQueryString) }"
        }
        
        return builder
    }
    
    public var gqlFragments: [GQLFragmentable.Type] {
        return content.gqlFragments
    }
    
    public var gqlQueryWithFragments: String {
        var builder = gqlQueryString
        if !content.gqlFragments.isEmpty {
            builder += " \(gqlFragmentString)"
        }
        return builder
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: GQLCodingKeys.self)
        try container.encode(gqlQueryWithFragments, forKey: .query)
        
        if !variables.isEmpty {
            let storage = GQLVariableStorage(storage: variables)
            try container.encode(storage, forKey: .variables)
        }
    }
}

private enum GQLCodingKeys: String, CodingKey {
    case query
    case variables
}

private struct GQLVariableStorage: Encodable {
    let storage: [String: GQLVariable]
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let sequence = storage.map { ($0.key, $0.value) }
        let wrappedDict = Dictionary
            .init(uniqueKeysWithValues: sequence)
            .mapValues(EncodableWrapper.init)
        try container.encode(wrappedDict)
    }
    
    struct EncodableWrapper: Encodable {
        let storage: Encodable?
        
        init(_ variable: GQLVariable?) {
            self.storage = variable
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            if let storage = storage {
                try storage.encode(to: &container)
            } else {
                try container.encodeNil()
            }
        }
    }
}
