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
        let mutation = GQLMutation {
            GQLNode("testMutation") {
                GQLNode("allNodes") {
                    "hi"
                    "ok"
                }
            }
            .withArgument(named: "thing", value: "ok")
        }
        XCTAssertEqual(mutation.gqlQueryWithFragments, #"mutation { testMutation(thing: "ok") { allNodes { hi ok } } }"#)
    }

    func testWithFragment() {
        let mutation = GQLMutation {
            GQLNode("testMutation") {
                GQLNode("allNodes") {
                    GQLFragment(Frag2.self)
                }
            }
            .withArgument(named: "thing", value: "ok")
        }
        XCTAssertEqual(mutation.gqlQueryWithFragments, #"mutation { testMutation(thing: "ok") { allNodes { ...frag2 } } } fragment frag2 on Frag2 { address birthday }"#)
    }
    
    func testAdvanced() {
        let mutation = GQLMutation {
            GQLNode("testMutation") {
                GQLNode("myQuery") {
                    GQLNode("frag1", alias: "allFrag1s") {
                        GQLFragment(Frag1.self)
                    }
                    .withArgument(named: "since", value: 20)
                    GQLNode("frag2") {
                        GQLFragment(Frag2.self)
                    }
                    "thing1"
                    "thing2"
                }
            }
            .withArgument(named: "thing", value: "ok")
        }
        XCTAssertEqual(mutation.gqlQueryWithFragments, #"mutation { testMutation(thing: "ok") { myQuery { allFrag1s: frag1(since: 20) { ...fragment1 } frag2 { ...frag2 } thing1 thing2 } } } fragment frag2 on Frag2 { address birthday } fragment fragment1 on Fragment1 { age name }"#)
    }
    
    func testWithArray() {
        let mutation = GQLMutation {
            GQLNode("testMutation") {
                GQLNode("one") {
                    GQLFragment(Frag1.self)
                }
                GQLNode("two") {
                    "no"
                    "maybe"
                    GQLFragment(Frag2.self)
                }
            }
            .withArgument(named: "thing", value: "ok")
        }
        XCTAssertEqual(mutation.gqlQueryWithFragments, #"mutation { testMutation(thing: "ok") { one { ...fragment1 } two { ...frag2 maybe no } } } fragment frag2 on Frag2 { address birthday } fragment fragment1 on Fragment1 { age name }"#)
    }
    
    func testWithArrayWithEmptyNode() {
        let mutation = GQLMutation {
            GQLNode("testMutation") {
                GQLNode("one")
                GQLNode("two") {
                    "no"
                    "maybe"
                    GQLFragment(Frag2.self)
                }
            }
            .withArgument(named: "thing", value: "ok")
        }
        XCTAssertEqual(mutation.gqlQueryWithFragments, #"mutation { testMutation(thing: "ok") { one two { ...frag2 maybe no } } } fragment frag2 on Frag2 { address birthday }"#)
    }
    
    static var allTests = [
        ("testWithoutFragment", testWithoutFragment),
        ("testWithFragment", testWithFragment),
        ("testAdvanced", testAdvanced),
        ("testWithArray", testWithArray),
        ("testWithArrayWithEmptyNode", testWithArrayWithEmptyNode)
    ]
}
