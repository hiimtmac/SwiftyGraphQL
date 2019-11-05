//
//  Fragment.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import Foundation

public protocol GraphQLFragment: GraphQLObject {
    static var fragmentName: String { get }
    static var fragmentContent: GraphQLRepresentable { get }
    static var fragmentStatement: String { get }
}

extension GraphQLFragment {
    public static var fragmentStatement: String {
        return "fragment \(fragmentName) on \(entityName) { \(fragmentContent.rawQuery) }"
    }
    
    public static var fragmentName: String {
        let name = "\(Self.self)"
        return name.lowercased()
    }
}
