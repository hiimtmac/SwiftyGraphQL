// Variable.swift
// Copyright © 2022 hiimtmac

import Foundation

public protocol GraphQLVariableExpression: Encodable {
    static var gqlScalar: GQLScalar { get }
}

extension GraphQLVariableExpression {
    public static var gqlScalar: GQLScalar { .custom("\(Self.self)") }
}

public struct GQLVariable: GraphQLExpression, Comparable {
    let name: String
    let value: GraphQLVariableExpression

    public init(name: String, value: GraphQLVariableExpression) {
        self.name = name
        self.value = value
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.name < rhs.name
    }

    public func serialize(to serializer: inout Serializer) {
        serializer.write("$")
        serializer.write(self.name)
        serializer.write(": ")
        type(of: self.value).gqlScalar.serialize(to: &serializer)

        serializer.write(variable: self)
    }
}

extension GQLVariable: GraphQLArgumentExpression {
    struct GQLVariableArgument: GraphQLExpression {
        let variable: GQLVariable

        func serialize(to serializer: inout Serializer) {
            serializer.write("$")
            serializer.write(self.variable.name)
            serializer.write(variable: self.variable)
        }
    }

    public var gqlArgument: GraphQLExpression { GQLVariableArgument(variable: self) }
}

extension String: GraphQLVariableExpression {
    public static var gqlScalar: GQLScalar { .string }
}

extension Int: GraphQLVariableExpression {
    public static var gqlScalar: GQLScalar { .int }
}

extension Float: GraphQLVariableExpression {
    public static var gqlScalar: GQLScalar { .float }
}

extension Double: GraphQLVariableExpression {
    public static var gqlScalar: GQLScalar { .float }
}

extension Bool: GraphQLVariableExpression {
    public static var gqlScalar: GQLScalar { .boolean }
}

extension Array: GraphQLVariableExpression where Element: GraphQLVariableExpression {
    public static var gqlScalar: GQLScalar { .array(of: Element.gqlScalar) }
}

// TODO: object encodable

extension Optional: GraphQLVariableExpression where Wrapped: GraphQLVariableExpression {
    public static var gqlScalar: GQLScalar { .optional(of: Wrapped.gqlScalar) }
}
