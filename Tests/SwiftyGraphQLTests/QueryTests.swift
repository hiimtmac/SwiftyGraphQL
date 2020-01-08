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
        let query = GQLQuery {
            GQLNode("allNodes") {
                "hi"
                "ok"
            }
        }
        XCTAssertEqual(query.gqlQueryWithFragments, #"query { allNodes { hi ok } }"#)
    }
    
    func testWithFragment() {
        let query = GQLQuery {
            GQLNode("allNodes") {
                GQLFragment(Frag2.self)
            }
        }
        XCTAssertEqual(query.gqlQueryWithFragments, #"query { allNodes { ...frag2 } } fragment frag2 on Frag2 { address birthday }"#)
    }
    
    func testAdvanced() {
        let query = GQLQuery {
            GQLNode("myQuery") {
                "thing1"
                "thing2"
                GQLNode("frag2") {
                    GQLFragment(Frag2.self)
                    GQLNode("frag1", alias: "allFrag1s") {
                        GQLFragment(Frag1.self)
                    }
                    .withArgument(named: "since", value: 20)
                    .withArgument(named: "name", value: "taylor")
                }
            }
        }
        XCTAssertEqual(query.gqlQueryWithFragments,  #"query { myQuery { frag2 { ...frag2 allFrag1s: frag1(name: "taylor", since: 20) { ...fragment1 } } thing1 thing2 } } fragment frag2 on Frag2 { address birthday } fragment fragment1 on Fragment1 { age name }"#)
    }
    
    func testWithArray() {
        let query = GQLQuery {
            GQLNode("one") {
                GQLFragment(Frag1.self)
            }
            GQLNode("two") {
                "no"
                "maybe"
                GQLFragment(Frag2.self)
            }
        }
        XCTAssertEqual(query.gqlQueryWithFragments, #"query { one { ...fragment1 } two { ...frag2 maybe no } } fragment frag2 on Frag2 { address birthday } fragment fragment1 on Fragment1 { age name }"#)
    }
    
    func testWithArrayWithEmptyNode() {
        let query = GQLQuery {
            GQLNode("one")
            GQLNode("two") {
                "no"
                "maybe"
                GQLFragment(Frag2.self)
            }
        }
        XCTAssertEqual(query.gqlQueryWithFragments, #"query { one two { ...frag2 maybe no } } fragment frag2 on Frag2 { address birthday }"#)
    }
}
