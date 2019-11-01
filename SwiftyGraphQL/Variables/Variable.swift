//
//  Variable.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-04-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public struct GraphQLVariable {
    let type: String
    let value: GraphQLVariableRepresentable?
    let defaultValue: GraphQLVariableRepresentable?
    
    public init<T>(value: T?, defaultValue: T) where T: GraphQLDefaultVariableRepresentable {
        self.type = "\(T.self.variableType) = \(defaultValue.parameterValue)"
        self.value = value
        self.defaultValue = defaultValue
    }
    
    public init<T>(value: T?) where T: GraphQLVariableRepresentable {
        self.type = "\(T.self.variableType)"
        self.value = value
        self.defaultValue = nil
    }
    
    public init<T>(value: T) where T: GraphQLVariableRepresentable {
        self.type = "\(T.self.variableType)!"
        self.value = value
        self.defaultValue = nil
    }
}
