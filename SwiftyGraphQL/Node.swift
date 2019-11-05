//
//  Node.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import Foundation

public protocol GraphQLRepresentable {
    var rawQuery: String { get }
    var fragments: String { get }
}

public enum GraphQLNode: GraphQLRepresentable {
    indirect case node(alias: String? = nil, name: String, arguments: GraphQLArguments? = nil, [GraphQLNode])
    case attributes([String])
    case fragment(GraphQLFragment.Type)
    
    public var rawQuery: String {
        switch self {
        case .node(let alias, let name, let arguments, let nodes):
            let adaptedCall: String
            if let alias = alias {
                adaptedCall = "\(alias): \(name)"
            } else {
                adaptedCall = name
            }
            
            let adaptedArguments = arguments?.statement ?? ""
            
            let nodeString = nodes
                .map { $0.rawQuery }
                .joined(separator: " ")
                        
            if nodes.isEmpty {
                return "\(adaptedCall)\(adaptedArguments)"
            } else {
                return "\(adaptedCall)\(adaptedArguments) { \(nodeString) }"
            }
        case .attributes(let attributes):
            return attributes
                .sorted()
                .joined(separator: " ")
        case .fragment(let type): return "...\(type.fragmentName)"
        }
    }
    
    var fragmentTypes: [GraphQLFragment.Type] {
        switch self {
        case .attributes: return []
        case .fragment(let type): return [type]
        case .node(_, _, _, let nodes):  return nodes.reduce([GraphQLFragment.Type](), { $0 + $1.fragmentTypes } )
        }
    }
    
    public var fragments: String {
        guard !fragmentTypes.isEmpty else { return "" }
        let fragments = fragmentTypes
            .map { $0.fragmentStatement }
        
        return Set(fragments)
            .sorted()
            .joined(separator: " ")
    }
    
    var sortOrder: Int {
        switch self {
        case .attributes: return 0
        case .fragment: return 1
        case .node: return 2
        }
    }
}

extension GraphQLNode: Equatable, Comparable {
    public static func == (lhs: GraphQLNode, rhs: GraphQLNode) -> Bool {
        switch (lhs, rhs) {
        case (.attributes(let l), .attributes(let r)): return l == r
        case (.fragment(let l), .fragment(let r)): return l == r
        case (.node(let la, let ln, _, _), .node(let ra, let rn, _, _)):
            return la == ra && ln == rn
        default: return false
        }
    }
    
    public static func <(lhs: Self, rhs: Self) -> Bool {
        if lhs.sortOrder == rhs.sortOrder {
            return lhs.rawQuery < rhs.rawQuery
        } else {
            return lhs.sortOrder < rhs.sortOrder
        }
    }
}

extension Array: GraphQLRepresentable where Element == GraphQLNode {
    public var rawQuery: String {
        return self
            .sorted()
            .map { $0.rawQuery }
            .joined(separator: " ")
    }
    
    public var fragments: String {
        let fragments = self
            .reduce([GraphQLFragment.Type](), { $0 + $1.fragmentTypes })
            .sorted { $0.fragmentName < $1.fragmentName }
            .map { $0.fragmentStatement }
        
        return Set(fragments)
            .sorted()
            .joined(separator: " ")
    }
}
