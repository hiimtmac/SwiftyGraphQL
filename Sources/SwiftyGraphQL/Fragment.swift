//
//  Fragment.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2020-01-07.
//  Copyright © 2020 hiimtmac. All rights reserved.
//

import Foundation

public protocol GQLFragmentable {
    static var fragmentName: String { get }
    static var fragmentType: String { get }
    static var gqlContent: GraphQL { get }
}

extension GQLFragmentable {
    public static var fragmentType: String { "\(Self.self)" }
    public static var fragmentName: String { fragmentType.lowercased() }
    static var fragmentString: String {
        return "fragment \(fragmentName) on \(fragmentType) { \(gqlContent.gqlQueryString) }"
    }
}

extension GQLFragmentable where Self: GQLAttributable, CodingKeys: CaseIterable, CodingKeys.RawValue == String {
    public static var gqlContent: GraphQL {
        GQLAttributes(Self.self)
    }
}

public struct GQLFragment: GraphQL {
    let name: String
    let type: String
    let fragment: GQLFragmentable.Type
    let content: GraphQL
    
    public init<T: GQLFragmentable>(_ type: T.Type) {
        self.name = type.fragmentName
        self.type = type.fragmentType
        self.fragment = type
        self.content = type.gqlContent
    }
    
    public var gqlQueryString: String {
        return "...\(name)"
    }
    
    public var gqlFragments: [GQLFragmentable.Type] {
        return [fragment]
    }
}
