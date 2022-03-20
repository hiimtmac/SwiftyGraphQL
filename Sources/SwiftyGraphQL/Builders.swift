// Builders.swift
// Copyright © 2022 hiimtmac

import Foundation

@resultBuilder
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
