// Scalar.swift
// Copyright © 2022 hiimtmac

import Foundation

public enum GQLScalar: GraphQLExpression, Equatable {
    case string
    case int
    case float
    case boolean
    case custom(String)
    indirect case array(of: GQLScalar)
    indirect case optional(of: GQLScalar)

    public func serialize(to serializer: inout Serializer) {
        switch self {
        case .string: serializer.write("String")
        case .int: serializer.write("Int")
        case .float: serializer.write("Float")
        case .boolean: serializer.write("Boolean")
        case let .custom(type): serializer.write(type)
        case let .array(type):
            serializer.write("[")
            type.serialize(to: &serializer)
            serializer.write("]")
        case let .optional(type): type.serialize(to: &serializer)
        }

        switch self {
        case .string, .int, .float, .boolean, .custom, .array:
            serializer.write("!")
        case .optional:
            serializer.pop()
        }
    }
}
