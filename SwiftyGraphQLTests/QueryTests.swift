//
//  QueryTests.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import XCTest
@testable import SwiftyGraphQL

class QueryTests: XCTestCase {

    func testWithoutFragment() {
        let node = GraphQLNode.node(nil, "allNodes", nil, [GraphQLNode.attributes(["hi", "ok"])])
        let query = GraphQLQuery(returning: node)
        let compare = #"query { allNodes: allNodes { hi ok } } "#
        XCTAssertEqual(query.query, compare)
    }
    
    func testWithFragment() {
        let node = GraphQLNode.node(nil, "allNodes", nil, [GraphQLNode.fragment(Frag2.self)])
        let query = GraphQLQuery(returning: node)
        let compare = #"query { allNodes: allNodes { ...frag2 } } fragment frag2 on Frag2 { address birthday }"#
        XCTAssertEqual(query.query, compare)
    }
    
    func testAdvanced() {
        let frag1 = GraphQLNode.node("allFrag1s", "frag1", GraphQLParameters(["since": 20, "name": "taylor"]), [.fragment(Frag1.self)])
        let frag2 = GraphQLNode.node(nil, "frag2", nil, [.fragment(Frag2.self), frag1])
        
        let node = GraphQLNode.node(nil, "myQuery", nil, [frag2, .attributes(["thing1", "thing2"])])
        let query = GraphQLQuery(returning: node)
        let compare = #"query { myQuery: myQuery { frag2: frag2 { ...frag2 allFrag1s: frag1(name: "taylor", since: 20) { ...fragment1 } } thing1 thing2 } } fragment frag2 on Frag2 { address birthday } fragment fragment1 on Fragment1 { age name }"#
        XCTAssertEqual(query.query, compare)
    }
    
    func testWithArray() {
        let one = GraphQLNode.node(nil, "one", nil, [.fragment(Frag1.self)])
        let two = GraphQLNode.node(nil, "two", nil, [.attributes(["no", "maybe"]), .fragment(Frag2.self)])
        
        let query = GraphQLQuery(returning: [one, two])
        let compare = #"query { one: one { ...fragment1 } two: two { no maybe ...frag2 } } fragment frag2 on Frag2 { address birthday } fragment fragment1 on Fragment1 { age name }"#
        XCTAssertEqual(query.query, compare)
    }
    
    func testWithArrayWithEmptyNode() {
        let one = GraphQLNode.node(nil, "one", nil, [])
        let two = GraphQLNode.node(nil, "two", nil, [.attributes(["no", "maybe"]), .fragment(Frag2.self)])
        
        let query = GraphQLQuery(returning: [one, two])
        let compare = #"query { one: one two: two { no maybe ...frag2 } } fragment frag2 on Frag2 { address birthday }"#
        XCTAssertEqual(query.query, compare)
    }
}
