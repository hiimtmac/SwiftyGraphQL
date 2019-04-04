//
//  Variable.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-04-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public struct GraphQLVariable {
    let key: String
    let value: GraphQLVariableEncodable?
    let variableParameter: String
    
    init<T>(key: String, value: T?, type: T.Type, default: T? = nil) where T: GraphQLVariableEncodable {
        self.key = key
        self.value = value
        if let def = `default` {
            self.variableParameter = "\(type.self) = \(def.asGraphQLParameter())"
        } else {
            self.variableParameter = "\(type.self)"
        }
    }
    
    init<T>(key: String, value: T, type: T.Type) where T: GraphQLVariableEncodable {
        self.key = key
        self.value = value
        self.variableParameter = "\(type.self)!"
    }
}

extension GraphQLVariable: GraphQLParameterEncodable {
    public func asGraphQLParameter() -> String {
        return "$\(key)"
    }
}
