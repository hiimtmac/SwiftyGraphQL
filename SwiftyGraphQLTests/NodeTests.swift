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
        let node = Node.node(nil, "myNode", nil, [.attributes(["hello", "hi"])])
        XCTAssertEqual(node.rawQuery, "myNode: myNode { hello hi }")
        XCTAssert(node.fragmentTypes.isEmpty)
    }
    
    func testTwoLevel() {
        let one = Node.node(nil, "one", nil, [.attributes(["hi", "yes"])])
        let two = Node.node(nil, "two", nil, [.attributes(["no", "maybe"]), one])
        let node = Node.node(nil, "myNode", nil, [.attributes(["hello", "hi"]), two])
        XCTAssertEqual(node.rawQuery, "myNode: myNode { hello hi two: two { no maybe one: one { hi yes } } }")
        XCTAssert(node.fragmentTypes.isEmpty)
    }
    
    func testWithParameters() {
        let node = Node.node(nil, "myNode", ["since": "4", "name": "\"taylor\""], [.attributes(["hello", "hi"])])
        XCTAssertEqual(node.rawQuery, "myNode: myNode(name: \"taylor\", since: 4) { hello hi }")
        XCTAssert(node.fragmentTypes.isEmpty)
    }
    
    func testWithAlias() {
        let node = Node.node("alias", "myNode", nil, [.attributes(["hello", "hi"])])
        XCTAssertEqual(node.rawQuery, "alias: myNode { hello hi }")
        XCTAssert(node.fragmentTypes.isEmpty)
    }
    
    func testOneLevelFragment() {
        let node = Node.node(nil, "myNode", nil, [.attributes(["hello", "hi"]), .fragment(Frag2.self)])
        XCTAssertEqual(node.rawQuery, "myNode: myNode { hello hi ...frag2 }")
        XCTAssertEqual(node.fragments, "fragment frag2 on Frag2 { birthday address }")
        XCTAssertEqual(node.fragmentTypes.count, 1)
    }
    
    func testTwoLevelFragment() {
        let one = Node.node(nil, "one", nil, [.attributes(["hi", "yes"]), .fragment(Frag1.self)])
        let two = Node.node(nil, "two", nil, [.attributes(["no", "maybe"]), one, .fragment(Frag2.self)])
        let node = Node.node(nil, "myNode", nil, [.attributes(["hello", "hi"]), two])
        XCTAssertEqual(node.rawQuery, "myNode: myNode { hello hi two: two { no maybe one: one { hi yes ...fragment1 } ...frag2 } }")
        XCTAssertEqual(node.fragments, "fragment frag2 on Frag2 { birthday address } fragment fragment1 on Fragment1 { name age }")
        XCTAssertEqual(node.fragmentTypes.count, 2)
    }
    
    func testNodeArray() {
        let one = Node.node(nil, "one", nil, [.fragment(Frag1.self)])
        let two = Node.node(nil, "two", nil, [.attributes(["no", "maybe"]), .fragment(Frag2.self)])
        let nodes = [one, two]
        XCTAssertEqual(nodes.rawQuery, "one: one { ...fragment1 } two: two { no maybe ...frag2 }")
        XCTAssertEqual(nodes.fragments, "fragment frag2 on Frag2 { birthday address } fragment fragment1 on Fragment1 { name age }")
    }
    
    func testEmptyNode() {
        let one = Node.node(nil, "one", nil, [])
        XCTAssertEqual(one.rawQuery, "one: one")
        XCTAssertEqual(one.fragments, "")
    }
    
    func testEmptyNodeWithOtherNode() {
        let one = Node.node(nil, "one", nil, [])
        let two = Node.node(nil, "two", nil, [.attributes(["no", "maybe"]), .fragment(Frag2.self)])
        let nodes = [one, two]
        XCTAssertEqual(nodes.rawQuery, "one: one two: two { no maybe ...frag2 }")
        XCTAssertEqual(nodes.fragments, "fragment frag2 on Frag2 { birthday address }")
    }
}
