// Fragments.swift
// Copyright © 2022 hiimtmac

import Foundation
import SwiftyGraphQL

struct Frag1: GQLFragmentable, Equatable {
    let name: String
    let age: String

    static var graqhQl: GraphQLExpression {
        "name"
        "age"
    }
}

struct Frag2: GQLFragmentable, GQLCodable, Equatable {
    let birthday: Date
    let address: String?

    enum CodingKeys: String, CodingKey, CaseIterable {
        case birthday
        case address
    }
}

struct Frag3: GQLFragmentable, GQLCodable, Equatable {
    let name: String
    let age: String
    let birthday: Date
    let address: String?

    enum CodingKeys: String, CodingKey, CaseIterable {
        case name
        case age
        case birthday
        case address
    }

    static let fragmentName = "fragment3"
    static let fragmentType = "Fragment3"
    static var graqhQl: GraphQLExpression {
        CodingKeys.name
        CodingKeys.age
        CodingKeys.address
        "cool"
    }
}
