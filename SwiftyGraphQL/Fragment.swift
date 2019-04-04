//
//  Fragment.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import Foundation

public protocol GraphQLFragmentRepresentable {
    static var entityName: String { get }
    static var fragmentName: String { get }
    static var attributes: [String] { get }
    
    static var fragment: String { get }
}

extension GraphQLFragmentRepresentable {
    public static var fragment: String {
        return "fragment \(fragmentName) on \(entityName) { \(attributes.joined(separator: " ")) }"
    }
    
    public static var entityName: String {
        let name = "\(Self.self)"
        return name.capitalized
    }
    
    public static var fragmentName: String {
        let name = "\(Self.self)"
        return name.lowercased()
    }
}
