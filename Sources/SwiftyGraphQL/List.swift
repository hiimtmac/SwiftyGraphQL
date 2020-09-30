//
//  File.swift
//  
//
//  Created by Taylor McIntyre on 2020-09-29.
//

import Foundation

public struct GQLList: GraphQLExpression {
    public let delimiter: String
    public let expressions: [GraphQLExpression]
    
    public init(_ expressions: [GraphQLExpression], delimiter: String) {
        self.expressions = expressions
        self.delimiter = delimiter
    }
    
    public func serialize(to serializer: inout Serializer) {
        for (i, g) in expressions.enumerated() {
            if (i > 0) {
                serializer.write(delimiter)
            }
            g.serialize(to: &serializer)
        }
    }
}
