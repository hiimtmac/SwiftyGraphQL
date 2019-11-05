//
//  Variable.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-04-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public struct GraphQLVariable {
    public let name: String
    public let value: GraphQLVariableRepresentable
    
    public init(name: String, value: GraphQLVariableRepresentable) {
        self.name = name
        self.value = value
    }
    
    public init(name: String, value: GraphQLVariableRepresentable?, default: GraphQLVariableRepresentable) {
        self.name = name
        self.value = value ?? `default`
    }
}

extension GraphQLVariable: Hashable {
    public static func == (lhs: GraphQLVariable, rhs: GraphQLVariable) -> Bool {
        return lhs.name == rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension GraphQLVariable: GraphQLArgument {
    public var parameterValue: String {
        return "$\(name)"
    }
}
