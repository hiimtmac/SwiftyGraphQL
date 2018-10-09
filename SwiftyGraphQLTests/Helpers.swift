//
//  Helpers.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import Foundation
import SwiftyGraphQL

struct Frag1: GraphQLFragmentRepresentable {
    let name: String
    let age: String
    
    static var entityName: String = "Fragment1"
    static var fragmentName: String = "fragment1"
    static var attributes: [String] = ["name", "age"]
}

struct Frag2: GraphQLFragmentRepresentable {
    let birthday: Date
    let address: String?
    
    static var attributes: [String] = ["birthday", "address"]
}
