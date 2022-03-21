// GQL.swift
// Copyright © 2022 hiimtmac

import Foundation

public struct GQL: GraphQLExpression {
    let type: OperationType
    let name: String?
    let variables: [String: GQLVariable]
    let content: GraphQLExpression

    public init(_ type: OperationType = .query, name: String? = nil, @GraphQLBuilder builder: () -> GraphQLExpression) {
        self.type = type
        self.name = name
        self.variables = [:]
        self.content = builder()
    }

    public enum OperationType: String {
        case query
        case mutation
    }

    public func serialize(to serializer: inout Serializer) {
        serializer.write(self.type.rawValue)

        if let name = name {
            serializer.writeSpace()
            serializer.write(name)
        }

        if !self.variables.isEmpty {
            serializer.write("(")
            GQLList(self.variables.map(\.value).sorted(), delimiter: ", ").serialize(to: &serializer)
            serializer.write(")")
        }

        serializer.writeSpace()
        serializer.write("{")
        serializer.writeSpace()
        self.content.serialize(to: &serializer)
        serializer.writeSpace()
        serializer.write("}")
    }
}

extension GQL {
    init(type: OperationType, name: String?, variables: [String: GQLVariable], content: GraphQLExpression) {
        self.type = type
        self.name = name
        self.variables = variables
        self.content = content
    }

    public func withVariable<T>(_ name: String, value: T) -> Self where T: GraphQLVariableExpression {
        let variable = GQLVariable(name: name, value: value)
        var variables = self.variables
        variables[name] = variable
        return .init(type: self.type, name: self.name, variables: variables, content: self.content)
    }

    public func withVariable(_ variable: GQLVariable) -> Self {
        var variables = self.variables
        variables[variable.name] = variable
        return .init(type: self.type, name: self.name, variables: variables, content: self.content)
    }
}

extension GQL: Encodable {
    enum GQLCodingKeys: String, CodingKey {
        case query
        case variables
    }

    public func encode(to encoder: Encoder) throws {
        var serializer = Serializer()
        self.serialize(to: &serializer)

        if !serializer.fragments.isEmpty {
            let fragmentBodies = serializer.fragments.map(\.value.fragmentBody).sorted()
            serializer.writeSpace()
            GQLList(fragmentBodies, delimiter: " ").serialize(to: &serializer)
        }

        var container = encoder.container(keyedBy: GQLCodingKeys.self)
        try container.encode(serializer.graphQL, forKey: .query)

        if !serializer.variables.isEmpty {
            let storage = GQLVariableStorage(variables: serializer.variables.map(\.value))
            try container.encode(storage, forKey: .variables)
        }
    }
}
