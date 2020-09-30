//
//  File.swift
//  
//
//  Created by Taylor McIntyre on 2020-09-30.
//

import Foundation

public struct GQLEmpty: GraphQLExpression {
    let name: String
    let alias: String?
    let arguments: [String: GQLArgument]
    let directive: GQLDirective?
    
    public init(_ name: String, alias: String? = nil) {
        self.name = name
        self.alias = alias
        self.arguments = [:]
        self.directive = nil
    }
    
    public func serialize(to serializer: inout Serializer) {
        if let alias = alias {
            serializer.write(alias)
            serializer.write(": ")
        }
        
        serializer.write(name)
        
        if !arguments.isEmpty {
            serializer.write("(")
            GQLList(arguments.map(\.value).sorted(), delimiter: ", ").serialize(to: &serializer)
            serializer.write(")")
        }
        
        if let directive = directive {
            serializer.writeSpace()
            directive.serialize(to: &serializer)
        }
    }
}

extension GQLEmpty {
    init(name: String, alias: String?, arguments: [String: GQLArgument], directive: GQLDirective?) {
        self.name = name
        self.alias = alias
        self.arguments = arguments
        self.directive = directive
    }
    
    public func withArgument<T>(_ name: String, value: T) -> Self where T: GraphQLArgumentExpression {
        let argument = GQLArgument(name: name, value: value)
        var arguments = self.arguments
        arguments[name] = argument
        return .init(name: self.name, alias: self.alias, arguments: arguments, directive: self.directive)
    }
    
    public func withArgument(_ name: String, variable: GQLVariable) -> Self {
        let argument = GQLArgument(name: name, value: variable)
        var arguments = self.arguments
        arguments[name] = argument
        return .init(name: self.name, alias: self.alias, arguments: arguments, directive: self.directive)
    }
    
    public func withArgument(_ name: String, variableName: String) -> Self {
        let variable = GQLStringVariableArgument(variableName)
        let argument = GQLArgument(name: name, value: variable)
        var arguments = self.arguments
        arguments[name] = argument
        return .init(name: self.name, alias: self.alias, arguments: arguments, directive: self.directive)
    }
    
    public func skipIf(_ variable: GQLVariable) -> Self {
        let directive = SkipDirective(if: variable)
        return .init(name: self.name, alias: self.alias, arguments: self.arguments, directive: directive)
    }
    
    public func skipIf(_ variableName: String) -> Self {
        let directive = SkipDirective(if: variableName)
        return .init(name: self.name, alias: self.alias, arguments: self.arguments, directive: directive)
    }
    
    public func includeIf(_ variable: GQLVariable) -> Self {
        let directive = IncludeDirective(if: variable)
        return .init(name: self.name, alias: self.alias, arguments: self.arguments, directive: directive)
    }
    
    public func includeIf(_ variableName: String) -> Self {
        let directive = IncludeDirective(if: variableName)
        return .init(name: self.name, alias: self.alias, arguments: self.arguments, directive: directive)
    }
}
