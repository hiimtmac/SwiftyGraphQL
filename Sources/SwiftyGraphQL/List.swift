// List.swift
// Copyright © 2022 hiimtmac

import Foundation

public struct GQLList: GraphQLExpression {
    public let delimiter: String
    public let expressions: [GraphQLExpression]

    public init(_ expressions: [GraphQLExpression], delimiter: String) {
        self.expressions = expressions
        self.delimiter = delimiter
    }

    public func serialize(to serializer: inout Serializer) {
        for (i, g) in self.expressions.enumerated() {
            if i > 0 {
                serializer.write(self.delimiter)
            }
            g.serialize(to: &serializer)
        }
    }
}
