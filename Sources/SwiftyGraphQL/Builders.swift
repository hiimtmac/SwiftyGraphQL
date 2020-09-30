//
//  Builder.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2020-01-07.
//  Copyright © 2020 hiimtmac. All rights reserved.
//

import Foundation

@_functionBuilder
public struct GraphQLBuilder {    
    public static func buildBlock(_ values: GraphQLExpression...) -> GraphQLExpression {
        GQLList(values, delimiter: " ")
    }
    
    public static func buildExpression(_ value: GraphQLExpression) -> GraphQLExpression {
        value
    }
    
    public static func buildExpression<T: RawRepresentable>(_ value: T) -> GraphQLExpression where T.RawValue == String {
        value.rawValue
    }
}
