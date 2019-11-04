//
//  NodeTests.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import XCTest
@testable import SwiftyGraphQL

class NodeTests: XCTestCase {

    func testOneLevel() {
        let node = GraphQLNode.node(name: "myNode", [.attributes(["hello", "hi"])])
        XCTAssertEqual(node.rawQuery, "myNode: myNode { hello hi }")
        XCTAssert(node.fragmentTypes.isEmpty)
    }
    
    func testTwoLevel() {
        let one = GraphQLNode.node(name: "one", [.attributes(["hi", "yes"])])
        let two = GraphQLNode.node(name: "two", [.attributes(["no", "maybe"]), one])
        let node = GraphQLNode.node(name: "myNode", [.attributes(["hello", "hi"]), two])
        XCTAssertEqual(node.rawQuery, "myNode: myNode { hello hi two: two { no maybe one: one { hi yes } } }")
        XCTAssert(node.fragmentTypes.isEmpty)
    }
    
    func testWithParameters() {
        let node = GraphQLNode.node(name: "myNode", parameters: GraphQLParameters(["since": 4, "name": "taylor"]), [.attributes(["hello", "hi"])])
        XCTAssertEqual(node.rawQuery, "myNode: myNode(name: \"taylor\", since: 4) { hello hi }")
        XCTAssert(node.fragmentTypes.isEmpty)
    }
    
    func testWithAlias() {
        let node = GraphQLNode.node(label: "alias", name: "myNode", [.attributes(["hello", "hi"])])
        XCTAssertEqual(node.rawQuery, "alias: myNode { hello hi }")
        XCTAssert(node.fragmentTypes.isEmpty)
    }
    
    func testOneLevelFragment() {
        let node = GraphQLNode.node(name: "myNode", [.attributes(["hello", "hi"]), .fragment(Frag2.self)])
        XCTAssertEqual(node.rawQuery, "myNode: myNode { hello hi ...frag2 }")
        XCTAssertEqual(node.fragments, "fragment frag2 on Frag2 { address birthday }")
        XCTAssertEqual(node.fragmentTypes.count, 1)
    }
    
    func testTwoLevelFragment() {
        let one = GraphQLNode.node(name: "one", [.attributes(["hi", "yes"]), .fragment(Frag1.self)])
        let two = GraphQLNode.node(name: "two", [.attributes(["no", "maybe"]), one, .fragment(Frag2.self)])
        let node = GraphQLNode.node(name: "myNode", [.attributes(["hello", "hi"]), two])
        XCTAssertEqual(node.rawQuery, "myNode: myNode { hello hi two: two { no maybe one: one { hi yes ...fragment1 } ...frag2 } }")
        XCTAssertEqual(node.fragments, "fragment frag2 on Frag2 { address birthday } fragment fragment1 on Fragment1 { age name }")
        XCTAssertEqual(node.fragmentTypes.count, 2)
    }
    
    func testNodeArray() {
        let one = GraphQLNode.node(name: "one", [.fragment(Frag1.self)])
        let two = GraphQLNode.node(name: "two", [.attributes(["no", "maybe"]), .fragment(Frag2.self)])
        let nodes = [one, two]
        XCTAssertEqual(nodes.rawQuery, "one: one { ...fragment1 } two: two { no maybe ...frag2 }")
        XCTAssertEqual(nodes.fragments, "fragment frag2 on Frag2 { address birthday } fragment fragment1 on Fragment1 { age name }")
    }
    
    func testEmptyNode() {
        let one = GraphQLNode.node(name: "one", [])
        XCTAssertEqual(one.rawQuery, "one: one")
        XCTAssertEqual(one.fragments, "")
    }
    
    func testEmptyNodeWithOtherNode() {
        let one = GraphQLNode.node(name: "one", [])
        let two = GraphQLNode.node(name: "two", [.attributes(["no", "maybe"]), .fragment(Frag2.self)])
        let nodes = [one, two]
        XCTAssertEqual(nodes.rawQuery, "one: one two: two { no maybe ...frag2 }")
        XCTAssertEqual(nodes.fragments, "fragment frag2 on Frag2 { address birthday }")
    }
}
