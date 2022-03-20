// Fragment.swift
// Copyright © 2022 hiimtmac

import Foundation

public protocol GQLFragmentable {
    static var fragmentName: String { get }
    static var fragmentType: String { get }
    @GraphQLBuilder
    static var graqhQl: GraphQLExpression { get }
}

extension GQLFragmentable {
    public static var fragmentType: String { "\(Self.self)" }
    public static var fragmentName: String { fragmentType.lowercased() }

    public static func asFragment() -> GQLFragment { .init(Self.self) }
}

public protocol GQLCodable: Codable {
    associatedtype CodingKeys: RawRepresentable & CaseIterable
}

extension GQLFragmentable where Self: GQLCodable, CodingKeys.RawValue == String {
    public static var graqhQl: GraphQLExpression {
        CodingKeys.allCases.map(\.rawValue)
    }
}

public struct GQLFragment: GraphQLExpression {
    let name: String
    let type: String
    let content: GraphQLExpression

    public init<T>(_ type: T.Type) where T: GQLFragmentable {
        self.name = type.fragmentName
        self.type = type.fragmentType
        self.content = type.graqhQl
    }

    public init(name: String, type: String, @GraphQLBuilder builder: () -> GraphQLExpression) {
        self.name = name
        self.type = type
        self.content = builder()
    }

    public func serialize(to serializer: inout Serializer) {
        serializer.write("...")
        serializer.write(self.name)
        serializer.write(fragment: self)
    }

    public var fragmentBody: GQLFragmentBody {
        .init(name: self.name, type: self.type, content: self.content)
    }
}

public struct GQLFragmentBody: GraphQLExpression, Comparable {
    let name: String
    let type: String
    let content: GraphQLExpression

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.name < rhs.name
    }

    public func serialize(to serializer: inout Serializer) {
        serializer.write("fragment")
        serializer.writeSpace()
        serializer.write(self.name)
        serializer.writeSpace()
        serializer.write("on")
        serializer.writeSpace()
        serializer.write(self.type)
        serializer.writeSpace()
        serializer.write("{")
        serializer.writeSpace()
        self.content.serialize(to: &serializer)
        serializer.writeSpace()
        serializer.write("}")
    }
}
