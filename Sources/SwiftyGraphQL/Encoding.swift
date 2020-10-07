//
//  File.swift
//  
//
//  Created by Taylor McIntyre on 2020-09-30.
//

import Foundation

struct GQLVariableStorage: Encodable {
    let storage: [String: GraphQLVariableExpression]
    
    init(variables: [GQLVariable]) {
        var dict = [String: GraphQLVariableExpression]()
        variables.forEach { dict[$0.name] = $0.value }
        self.storage = dict
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let sequence = storage.map { ($0.key, $0.value) }
        let wrappedDict = Dictionary
            .init(uniqueKeysWithValues: sequence)
            .mapValues(EncodableWrapper.init)
        
        try container.encode(wrappedDict)
    }
}

struct EncodableWrapper: Encodable {
    let storage: Encodable?
    
    init(_ variable: GraphQLVariableExpression?) {
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
