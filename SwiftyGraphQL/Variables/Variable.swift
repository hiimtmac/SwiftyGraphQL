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
    let value: GraphQLArgument?
    let `default`: GraphQLArgument?
    let variableParameter: String
    
    init<T>(key: String, value: T?, type: T.Type, default: T? = nil) where T: GraphQLArgument {
        self.key = key
        self.value = value
        self.default = `default`
        if let def = `default` {
            self.variableParameter = "\(type.self) = \(def.graphQLEncoded())"
        } else {
            self.variableParameter = "\(type.self)"
        }
    }
    
    init<T>(key: String, value: T, type: T.Type) where T: GraphQLArgument {
        self.key = key
        self.value = value
        self.variableParameter = "\(type.self)!"
        self.default = nil
    }
}

extension GraphQLVariable: GraphQLArgument {
    public func graphQLEncoded() -> String {
        return "$\(key)"
    }
}
