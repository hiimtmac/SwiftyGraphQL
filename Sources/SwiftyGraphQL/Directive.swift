//
//  Directive.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2020-01-08.
//  Copyright © 2020 hiimtmac. All rights reserved.
//

import Foundation

public protocol GQLDirective: GraphQLExpression {}

public struct SkipDirective: GQLDirective {
    let argument: GraphQLArgumentExpression
    
    public init(if variable: GQLVariable) {
        self.argument = variable
    }
    
    public init(if variableName: String) {
        self.argument = GQLStringVariableArgument(variableName)
    }
    
    public func serialize(to serializer: inout Serializer) {
        serializer.write("@skip(if: ")
        argument.gqlArgument.serialize(to: &serializer)
        serializer.write(")")
    }
}

public struct IncludeDirective: GQLDirective {
    let argument: GraphQLArgumentExpression
    
    public init(if variable: GQLVariable) {
        self.argument = variable
    }
    
    public init(if variableName: String) {
        self.argument = GQLStringVariableArgument(variableName)
    }
    
    public func serialize(to serializer: inout Serializer) {
        serializer.write("@include(if: ")
        argument.gqlArgument.serialize(to: &serializer)
        serializer.write(")")
    }
}
