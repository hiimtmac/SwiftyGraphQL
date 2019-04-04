//
//  Variable.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-04-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public struct GraphQLVariable: Encodable {
    let key: String
    let value: GraphQLVariableEncodable?
    let variableParameter: String
    
    init<T>(key: String, value: T?, type: T.Type, default: T? = nil) where T: GraphQLVariableEncodable {
        self.key = key
        self.value = value
        if let def = `default` {
            self.variableParameter = "\(type.self) = \(def.graphQLEncoded())"
        } else {
            self.variableParameter = "\(type.self)"
        }
    }
    
    init<T>(key: String, value: T, type: T.Type) where T: GraphQLVariableEncodable {
        self.key = key
        self.value = value
        self.variableParameter = "\(type.self)!"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(value?.graphQLEncoded())
    }
}

extension GraphQLVariable: GraphQLArgument {
    public func graphQLEncoded() -> String {
        return "$\(key)"
    }
}
