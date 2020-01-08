//
//  GraphQL.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2020-01-07.
//  Copyright © 2020 hiimtmac. All rights reserved.
//

import Foundation

public protocol GraphQL {
    var gqlQueryString: String { get }
    var gqlFragments: [GQLFragmentable.Type] { get }
    var gqlFragmentString: String { get }
}

extension GraphQL {
    public var gqlFragments: [GQLFragmentable.Type] { [] }
    public var gqlFragmentString: String {
        return Set(gqlFragments.map { $0.fragmentString })
            .sorted()
            .joined(separator: " ")
    }
}

extension Array: GraphQL where Element == GraphQL {
    public var gqlQueryString: String {
        return self
            .map { $0.gqlQueryString }
            .sorted()
            .joined(separator: " ")
    }
    
    public var gqlFragments: [GQLFragmentable.Type] {
        return self
            .map { $0.gqlFragments }
            .reduce([GQLFragmentable.Type](), +)
    }
}

extension String: GraphQL {
    public var gqlQueryString: String { self }
}
