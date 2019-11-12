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
    let type: String
    public let value: GraphQLVariableRepresentable?
    
    public init<T: GraphQLVariableRepresentable>(name: String, value: T?) {
        self.name = name
        self.value = value
        self.type = T.variableType
    }
    
    public init<T: GraphQLVariableRepresentable>(name: String, value: T) {
        self.name = name
        self.value = value
        self.type = "\(T.variableType)!"
    }

    public init<T: GraphQLVariableRepresentable>(name: String, value: [T]?) {
        self.name = name
        self.value = value
        self.type = "[\(T.variableType)!]"
    }

    public init<T: GraphQLVariableRepresentable>(name: String, value: [T]) {
        self.name = name
        self.value = value
        self.type = "[\(T.variableType)!]!"
    }

    public init<T: GraphQLVariableRepresentable>(name: String, value: [T?]?) {
        self.name = name
        self.value = value
        self.type = "[\(T.variableType)]"
    }

    public init<T: GraphQLVariableRepresentable>(name: String, value: [T?]) {
        self.name = name
        self.value = value
        self.type = "[\(T.variableType)]!"
    }
    
    var parameter: String {
        return "$\(name): \(type)"
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
