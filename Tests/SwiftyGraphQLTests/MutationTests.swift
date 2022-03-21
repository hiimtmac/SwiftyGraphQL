// MutationTests.swift
// Copyright © 2022 hiimtmac

import XCTest
@testable import SwiftyGraphQL

class MutationTests: BaseTestCase {
    func testWithoutFragment() {
        GQL(.mutation) {
            GQLNode("testMutation") {
                GQLNode("allNodes") {
                    "hi"
                    "ok"
                }
            }
            .withArgument("thing", value: "ok")
        }
        .serialize(to: &serializer)

        XCTAssertEqual(graphQL, #"mutation { testMutation(thing: "ok") { allNodes { hi ok } } }"#)
        XCTAssert(fragmentQL.isEmpty)
    }

    func testWithFragment() {
        GQL(.mutation) {
            GQLNode("testMutation") {
                GQLNode("allNodes") {
                    GQLFragment(Frag2.self)
                }
            }
            .withArgument("thing", value: "ok")
        }
        .serialize(to: &serializer)

        XCTAssertEqual(graphQL, #"mutation { testMutation(thing: "ok") { allNodes { ...frag2 } } }"#)
        XCTAssertEqual(fragmentQL, #"fragment frag2 on Frag2 { birthday address }"#)
    }

    func testAdvanced() {
        GQL(.mutation) {
            GQLNode("testMutation") {
                GQLNode("myQuery") {
                    GQLNode("frag1", alias: "allFrag1s") {
                        GQLFragment(Frag1.self)
                    }
                    .withArgument("since", value: 20)
                    GQLNode("frag2") {
                        GQLFragment(Frag2.self)
                    }
                    "thing1"
                    "thing2"
                }
            }
            .withArgument("thing", value: "ok")
        }
        .serialize(to: &serializer)

        XCTAssertEqual(graphQL, #"mutation { testMutation(thing: "ok") { myQuery { allFrag1s: frag1(since: 20) { ...frag1 } frag2 { ...frag2 } thing1 thing2 } } }"#)
        XCTAssertEqual(fragmentQL, #"fragment frag1 on Frag1 { name age } fragment frag2 on Frag2 { birthday address }"#)
    }

    func testWithArray() {
        GQL(.mutation) {
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
            .withArgument("thing", value: "ok")
        }
        .serialize(to: &serializer)

        XCTAssertEqual(graphQL, #"mutation { testMutation(thing: "ok") { one { ...frag1 } two { no maybe ...frag2 } } }"#)
        XCTAssertEqual(fragmentQL, #"fragment frag1 on Frag1 { name age } fragment frag2 on Frag2 { birthday address }"#)
    }

    func testWithArrayWithEmptyNode() {
        GQL(.mutation) {
            GQLNode("testMutation") {
                GQLNode("one") {}
                GQLNode("two") {
                    "no"
                    "maybe"
                    GQLFragment(Frag2.self)
                }
            }
            .withArgument("thing", value: "ok")
        }
        .serialize(to: &serializer)

        XCTAssertEqual(graphQL, #"mutation { testMutation(thing: "ok") { one {  } two { no maybe ...frag2 } } }"#)
        XCTAssertEqual(fragmentQL, #"fragment frag2 on Frag2 { birthday address }"#)
    }

    static var allTests = [
        ("testWithoutFragment", testWithoutFragment),
        ("testWithFragment", testWithFragment),
        ("testAdvanced", testAdvanced),
        ("testWithArray", testWithArray),
        ("testWithArrayWithEmptyNode", testWithArrayWithEmptyNode),
    ]
}
