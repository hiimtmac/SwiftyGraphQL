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
    indirect case node(String?, String, GraphQLParameters?, [GraphQLNode])
    case attributes([String])
    case fragment(GraphQLFragmentRepresentable.Type)
    
    public var rawQuery: String {
        switch self {
        case .node(let label, let name, let parameters, let nodes):
            let nodeString = nodes
                .map { $0.rawQuery }
                .joined(separator: " ")
                        
            if nodes.isEmpty {
                return "\(label ?? name): \(name)\(parameters?.statement ?? "")"
            } else {
                return "\(label ?? name): \(name)\(parameters?.statement ?? "") { \(nodeString) }"
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
    
    public var fragments: String {
        let fragments = fragmentTypes
            .map { $0.fragment }
        
        let set = Set(fragments).sorted()
        return set.joined(separator: " ")
    }
}

extension Array: GraphQLRepresentable where Iterator.Element == GraphQLNode {
    public var rawQuery: String {
        return self
            .map { $0.rawQuery }
            .sorted()
            .joined(separator: " ")
    }
    
    public var fragments: String {
        let fragments = self
            .reduce([GraphQLFragmentRepresentable.Type](), { $0 + $1.fragmentTypes })
            .map { $0.fragment }
        
        let set = Set(fragments).sorted()
        return set.joined(separator: " ")
    }
}
