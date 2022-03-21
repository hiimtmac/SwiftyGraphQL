// Expression.swift
// Copyright © 2022 hiimtmac

import Foundation

public protocol GraphQLExpression {
    func serialize(to serializer: inout Serializer)
}

extension String: GraphQLExpression {
    public func serialize(to serializer: inout Serializer) {
        serializer.write(self)
    }
}

extension Array: GraphQLExpression where Element: GraphQLExpression {
    public func serialize(to serializer: inout Serializer) {
        for (i, g) in self.enumerated() {
            if i > 0 {
                serializer.writeSpace()
            }
            g.serialize(to: &serializer)
        }
    }
}
