//
//  Attributes.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2020-01-07.
//  Copyright © 2020 hiimtmac. All rights reserved.
//

import Foundation

public typealias GQLCodedKey = RawRepresentable & CodingKey

public protocol GQLAttributable {
    associatedtype CodingKeys: GQLCodedKey
}

public struct GQLAttributes: GraphQL {
    let content: GraphQL
    
    public init(@GraphQLBuilder builder: () -> GraphQL) {
        self.content = builder()
    }
    
    public init<T: GQLAttributable>(_ type: T.Type, @CodingKeyBuilder builder: (T.CodingKeys.Type) -> GraphQL) {
        self.content = builder(type.CodingKeys.self)
    }
    
    public init<T: GQLAttributable>(_ type: T.Type) where T.CodingKeys: CaseIterable, T.CodingKeys.RawValue == String {
        self.content = type.CodingKeys.allCases.map { $0.rawValue }
    }
    
    public var gqlQueryString: String {
        return content.gqlQueryString
    }
}
