//
//  MutationTests.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import XCTest
@testable import SwiftyGraphQL

class MutationTests: XCTestCase {

    func testWithoutFragment() {
        let node = Node.node(nil, "allNodes", nil, [Node.attributes(["hi", "ok"])])
        let mutation = GraphQLMutation(mutation: "testMutation(thing: \"ok\")", returning: node)
        XCTAssertEqual(mutation.query, "mutation { testMutation(thing: \"ok\") { allNodes: allNodes { hi ok } } } ")
    }

    func testWithFragment() {
        let node = Node.node(nil, "allNodes", nil, [Node.fragment(Frag2.self)])
        let mutation = GraphQLMutation(mutation: "testMutation(thing: \"ok\")", returning: node)
        XCTAssertEqual(mutation.query, "mutation { testMutation(thing: \"ok\") { allNodes: allNodes { ...frag2 } } } fragment frag2 on Frag2 { birthday address }")
    }
    
    func testAdvanced() {
        let frag1 = Node.node("allFrag1s", "frag1", ["since": "20"], [.fragment(Frag1.self)])
        let frag2 = Node.node(nil, "frag2", nil, [.fragment(Frag2.self)])
        
        let node = Node.node(nil, "myQuery", nil, [frag1, frag2, .attributes(["thing1", "thing2"])])
        let mutation = GraphQLMutation(mutation: "testMutation(thing: \"ok\")", returning: node)
        XCTAssertEqual(mutation.query, "mutation { testMutation(thing: \"ok\") { myQuery: myQuery { allFrag1s: frag1(since: 20) { ...fragment1 } frag2: frag2 { ...frag2 } thing1 thing2 } } } fragment frag2 on Frag2 { birthday address } fragment fragment1 on Fragment1 { name age }")
    }
    
    func testWithArray() {
        let one = Node.node(nil, "one", nil, [.fragment(Frag1.self)])
        let two = Node.node(nil, "two", nil, [.attributes(["no", "maybe"]), .fragment(Frag2.self)])
        
        let mutation = GraphQLMutation(mutation: "testMutation(thing: \"ok\")", returning: [one, two])
        XCTAssertEqual(mutation.query, "mutation { testMutation(thing: \"ok\") { one: one { ...fragment1 } two: two { no maybe ...frag2 } } } fragment frag2 on Frag2 { birthday address } fragment fragment1 on Fragment1 { name age }")
    }
    
    func testWithArrayWithEmptyNode() {
        let one = Node.node(nil, "one", nil, [])
        let two = Node.node(nil, "two", nil, [.attributes(["no", "maybe"]), .fragment(Frag2.self)])
        
        let mutation = GraphQLMutation(mutation: "testMutation(thing: \"ok\")", returning: [one, two])
        XCTAssertEqual(mutation.query, "mutation { testMutation(thing: \"ok\") { one: one two: two { no maybe ...frag2 } } } fragment frag2 on Frag2 { birthday address }")
    }
}
