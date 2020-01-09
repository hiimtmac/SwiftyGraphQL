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
    
    public func withVariable(named: String, variableName: String) -> Self {
        struct Arg: GQLArgument {
            var gqlArgumentValue: String
            
            init(name: String) {
                gqlArgumentValue = "$\(name)"
            }
        }
        
        var copyArgs = arguments
        copyArgs[named] = Arg(name: variableName)
        
        return .init(name, alias: alias, arguments: copyArgs, directive: directive, content: content)
    }
    
    public func withDirective(_ directive: GQLDirective) -> Self {
        return .init(name, alias: alias, arguments: arguments, directive: directive, content: content)
    }
}
