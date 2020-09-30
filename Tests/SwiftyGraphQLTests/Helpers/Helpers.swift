//
//  Helpers.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

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

struct TestEncoded<T>: Decodable, Equatable where T: Decodable & Equatable {
    let query: String
    let variables: T
}

struct TestRequest<T: Encodable>: Encodable {
    let data: T?
    let errors: [TestError]?
    
    init(data: T?, errors: [TestError]?) {
        self.data = data
        self.errors = errors
    }
    
    struct TestError: Encodable {
        let message: String
    }
}

extension Data {
    func string() -> String {
        String(decoding: self, as: UTF8.self)
    }
}
