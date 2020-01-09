//
//  Builder.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2020-01-07.
//  Copyright © 2020 hiimtmac. All rights reserved.
//

import Foundation

@_functionBuilder
public struct GraphQLBuilder {
    public static func buildBlock(_ children: GraphQL...) -> GraphQL {
        return children
    }
}

@_functionBuilder
public struct CodingKeyBuilder {
    public static func buildBlock<T: RawRepresentable>(_ children: T...) -> GraphQL where T.RawValue == String {
        return children
            .map { $0.rawValue }
    }
}
