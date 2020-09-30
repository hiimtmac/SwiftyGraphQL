//
//  File.swift
//  
//
//  Created by Taylor McIntyre on 2020-09-29.
//

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
        serializer.write(type.rawValue)
        
        if let name = name {
            serializer.writeSpace()
            serializer.write(name)
        }
        
        if !variables.isEmpty {
            serializer.write("(")
            GQLList(variables.map(\.value).sorted(), delimiter: ", ").serialize(to: &serializer)
            serializer.write(")")
        }
        
        serializer.writeSpace()
        serializer.write("{")
        serializer.writeSpace()
        content.serialize(to: &serializer)
        serializer.writeSpace()
        serializer.write("}")
    }
    
    public func encode(encoder: JSONEncoder = .init()) throws -> Data {
        var gqlSerializer = Serializer()
        self.serialize(to: &gqlSerializer)
        
        var query = gqlSerializer.graphQL
        
        if !gqlSerializer.fragments.isEmpty {
            var fragmentSerializer = Serializer()
            let fragmentBodies = gqlSerializer.fragments.map(\.value.fragmentBody).sorted()
            GQLList(fragmentBodies, delimiter: " ").serialize(to: &fragmentSerializer)
            query += " "
            query += fragmentSerializer.graphQL
        }
        
        let encodable = GQLEncoded(query: query, variables: gqlSerializer.variables.map(\.value))
        return try encoder.encode(encodable)
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
