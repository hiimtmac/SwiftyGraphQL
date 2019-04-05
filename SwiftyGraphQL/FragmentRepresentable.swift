//
//  Fragment.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import Foundation

public protocol GraphQLFragmentRepresentable: GraphQLObject {
    static var fragmentName: String { get }
    static var attributes: [String] { get }
    
    static var fragmentStatement: String { get }
}

extension GraphQLFragmentRepresentable {
    public static var fragmentStatement: String {
        return "fragment \(fragmentName) on \(entityName) { \(attributes.sorted().joined(separator: " ")) }"
    }
    
    public static var fragmentName: String {
        let name = "\(Self.self)"
        return name.lowercased()
    }
}
