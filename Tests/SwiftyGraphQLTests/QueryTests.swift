//
//  QueryTests.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2018-10-09.
//  Copyright © 2018 hiimtmac All rights reserved.
//

import XCTest
import SwiftyGraphQL

class QueryTests: BaseTestCase {

    func testWithoutFragment() {
        GQL(.query) {
            GQLNode("allNodes") {
                "hi"
                "ok"
            }
        }
        .serialize(to: &serializer)
        
        XCTAssertEqual(graphQL, #"query { allNodes { hi ok } }"#)
        XCTAssert(fragmentQL.isEmpty)
    }
    
    func testWithFragment() {
        GQL(.query) {
            GQLNode("allNodes") {
                GQLFragment(Frag2.self)
            }
        }
        .serialize(to: &serializer)
        
        XCTAssertEqual(graphQL, #"query { allNodes { ...frag2 } }"#)
        XCTAssertEqual(fragmentQL, #"fragment frag2 on Frag2 { birthday address }"#)
    }
    
    func testAdvanced() {
        GQL(.query) {
            GQLNode("myQuery") {
                "thing1"
                "thing2"
                GQLNode("frag2") {
                    Frag2.asFragment()
                    GQLNode("frag1", alias: "allFrag1s") {
                        GQLFragment(Frag1.self)
                    }
                    .withArgument("since", value: 20)
                    .withArgument("name", value: "taylor")
                }
            }
        }
        .serialize(to: &serializer)
        
        XCTAssertEqual(graphQL,  #"query { myQuery { thing1 thing2 frag2 { ...frag2 allFrag1s: frag1(name: "taylor", since: 20) { ...frag1 } } } }"#)
        XCTAssertEqual(fragmentQL,  #"fragment frag1 on Frag1 { name age } fragment frag2 on Frag2 { birthday address }"#)
    }
    
    func testWithArray() {
        GQL(.query) {
            GQLNode("one") {
                Frag1.asFragment()
            }
            GQLNode("two") {
                "no"
                "maybe"
                Frag3.asFragment()
            }
        }
        .serialize(to: &serializer)
        
        XCTAssertEqual(graphQL, #"query { one { ...frag1 } two { no maybe ...fragment3 } }"#)
        XCTAssertEqual(fragmentQL, #"fragment frag1 on Frag1 { name age } fragment fragment3 on Fragment3 { name age address cool }"#)
    }

    func testWithArrayWithEmptyNode() {
        GQL(.query) {
            GQLNode("one") {}
            GQLNode("two") {
                "no"
                "maybe"
                Frag2.asFragment()
            }
        }
        .serialize(to: &serializer)
        
        XCTAssertEqual(graphQL, #"query { one {  } two { no maybe ...frag2 } }"#)
        XCTAssertEqual(fragmentQL, #"fragment frag2 on Frag2 { birthday address }"#)
    }
    
    static var allTests = [
        ("testWithoutFragment", testWithoutFragment),
        ("testWithFragment", testWithFragment),
        ("testAdvanced", testAdvanced),
        ("testWithArray", testWithArray),
        ("testWithArrayWithEmptyNode", testWithArrayWithEmptyNode)
    ]
}
