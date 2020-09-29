//
//  Node.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2020-01-07.
//  Copyright © 2020 hiimtmac. All rights reserved.
//

import Foundation

public struct GQLNode: GraphQL {
    let name: String
    let alias: String?
    let arguments: [String: GQLArgument]
    let directive: GQLDirective?
    let content: GraphQL

    public init(_ name: String, @GraphQLBuilder builder: () -> GraphQL) {
        self.name = name
        self.alias = nil
        self.arguments = [:]
        self.directive = nil
        self.content = builder()
    }
    
    public init(_ name: String, alias: String, @GraphQLBuilder builder: () -> GraphQL) {
        self.name = name
        self.alias = alias
        self.arguments = [:]
        self.directive = nil
        self.content = builder()
    }
    
    public init(_ name: String, alias: String? = nil) {
        self.name = name
        self.alias = alias
        self.arguments = [:]
        self.directive = nil
        self.content = ""
    }
    
    init(_ name: String, alias: String?, arguments: [String: GQLArgument], directive: GQLDirective?, content: GraphQL) {
        self.name = name
        self.alias = alias
        self.arguments = arguments
        self.directive = directive
        self.content = content
    }
    
    public var gqlQueryString: String {
        var builder = ""
        
        if let alias = alias {
            builder += "\(alias): "
        }
        
        builder += name
        
        if !arguments.isEmpty {
            let args = arguments
                .map { "\($0.key): \($0.value.gqlArgumentValue)" }
                .sorted()
                .joined(separator: ", ")
            
            builder += "(\(args))"
        }
        
        if let directive = directive {
            builder += " \(directive.gqlDirectiveString)"
        }
        
        if !content.gqlQueryString.isEmpty {
            builder += " { \(content.gqlQueryString) }"
        }
        
        return builder
    }
    
    public var gqlFragments: [GQLFragmentable.Type] {
        return content.gqlFragments
    }
}

extension GQLNode {
    public func withArgument(named: String, value: GQLArgument?) -> Self {
        var copyArgs = arguments
        copyArgs[named] = value
        
        return .init(name, alias: alias, arguments: copyArgs, directive: directive, content: content)
    }
    
    public func withArguments(_ arguments: [String: GQLArgument]) -> Self {
        var copyArgs = self.arguments
        arguments.forEach { copyArgs[$0.key] = $0.value }
        
        return .init(name, alias: alias, arguments: copyArgs, directive: directive, content: content)
    }
    
    public func withVariable(named: String, variableName: String) -> Self {
        var copyArgs = self.arguments
        copyArgs[named] = Arg(name: variableName)
        
        return .init(name, alias: alias, arguments: copyArgs, directive: directive, content: content)
    }
    
    public func withVariable(named: String, variables: [String: String]) -> Self {
        var copyArgs = self.arguments
        copyArgs[named] = ObjArg(variables)

        return .init(name, alias: alias, arguments: copyArgs, directive: directive, content: content)
    }
    
    public func withVariables(_ variables: [String: String]) -> Self {
        var copyArgs = self.arguments
        variables.forEach { copyArgs[$0.key] = Arg(name: $0.value) }
        
        return .init(name, alias: alias, arguments: copyArgs, directive: directive, content: content)
    }
    
    public func withDirective(_ directive: GQLDirective) -> Self {
        return .init(name, alias: alias, arguments: arguments, directive: directive, content: content)
    }
    
    private struct Arg: GQLArgument {
        var gqlArgumentValue: String
        
        init(name: String) {
            gqlArgumentValue = "$\(name)"
        }
    }
    
    private struct ObjArg: GQLArgument {
        var gqlArgumentValue: String
        
        init(_ values: [String: String]) {
            var value = "{"
            let enumeration = values
                .sorted { $0.key < $1.key }
                .enumerated()
            
            for (i, v) in enumeration {
                if i > 0 {
                    value += ","
                }
                value += " \(v.key): $\(v.value)"
            }
            
            value += " }"
            gqlArgumentValue = value
        }
    }
}
