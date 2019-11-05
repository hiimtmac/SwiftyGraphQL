//
//  Helpers.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import Foundation
import SwiftyGraphQL

struct Frag1: GraphQLFragment, Codable, Equatable {
    let name: String
    let age: String
    
    static var entityName: String = "Fragment1"
    static var fragmentName: String = "fragment1"
    static var fragmentContent: GraphQLRepresentable {
        return GraphQLNode.attributes(["name", "age"])
    }
}

struct Frag2: GraphQLFragment, Codable, Equatable {
    let birthday: Date
    let address: String?
    
    static var fragmentContent: GraphQLRepresentable {
        return GraphQLNode.attributes(["birthday", "address"])
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
