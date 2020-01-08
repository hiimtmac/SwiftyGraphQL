//
//  Helpers.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import Foundation
import SwiftyGraphQL

struct Frag1: GQLFragmentable, Codable, Equatable {
    static let fragmentName = "fragment1"
    static let fragmentType = "Fragment1"
    
    let name: String
    let age: String
    
    static var gqlContent: GraphQL {
        GQLAttributes {
            "name"
            "age"
        }
    }
}

struct Frag2: GQLFragmentable, Codable, Equatable {
    static let fragmentName = "frag2"
    static let fragmentType = "Frag2"
    
    let birthday: Date
    let address: String?
    
    enum CodingKeys: String, GQLCodedKey, CaseIterable {
        case birthday
        case address
    }
    
    static var gqlContent: GraphQL {
        GQLAttributes {
            "birthday"
            "address"
        }
    }
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
