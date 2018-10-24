//
//  Node.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import Foundation

public protocol GraphQLRepresentable {
    var rawQuery: GraphQLStatement { get }
    var fragments: GraphQLStatement { get }
}

public enum Node: GraphQLRepresentable {
    indirect case node(String?, String, [String: String]?, [Node])
    case attributes([String])
    case fragment(GraphQLFragmentRepresentable.Type)
    
    public var rawQuery: GraphQLStatement {
        switch self {
        case .node(let label, let name, let parameters, let nodes):
            let nodeString = nodes
                .map { $0.rawQuery }
                .joined(separator: " ")
            
            var parameterString = ""
            if let parameters = parameters {
                let params = parameters
                    .map { "\($0.key): \($0.value)" }
                    .sorted()
                    .joined(separator: ", ")
                parameterString = "(\(params))"
            }
            
            if nodes.isEmpty {
                return "\(label ?? name): \(name)\(parameterString)"
            } else {
                return "\(label ?? name): \(name)\(parameterString) { \(nodeString) }"
            }
        case .attributes(let attributes): return attributes.joined(separator: " ")
        case .fragment(let type): return "...\(type.fragmentName)"
        }
    }
    
    var fragmentTypes: [GraphQLFragmentRepresentable.Type] {
        switch self {
        case .attributes: return []
        case .fragment(let type): return [type]
        case .node(_, _, _, let nodes):  return nodes.reduce([GraphQLFragmentRepresentable.Type](), { $0 + $1.fragmentTypes } )
        }
    }
    
    public var fragments: GraphQLStatement {
        let fragments = fragmentTypes
            .map { $0.fragment }
        
        let set = Set(fragments).sorted()
        return set.joined(separator: " ")
    }
}

extension Array: GraphQLRepresentable where Iterator.Element == Node {
    public var rawQuery: GraphQLStatement {
        return self
            .map { $0.rawQuery }
            .sorted()
            .joined(separator: " ")
    }
    
    public var fragments: GraphQLStatement {
        let fragments = self
            .reduce([GraphQLFragmentRepresentable.Type](), { $0 + $1.fragmentTypes })
            .map { $0.fragment }
        
        let set = Set(fragments).sorted()
        return set.joined(separator: " ")
    }
}
