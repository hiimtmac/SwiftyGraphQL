// NodeTests.swift
// Copyright © 2022 hiimtmac

import SwiftyGraphQL
import XCTest

class NodeTests: BaseTestCase {
    func testSimple() {
        GQLNode("cool") {
            "hi"
            "there"
        }
        .serialize(to: &serializer)

        XCTAssertEqual(graphQL, "cool { hi there }")
    }

    func testAlias() {
        GQLNode("cool", alias: "beans") {
            "hi"
        }
        .serialize(to: &serializer)

        XCTAssertEqual(graphQL, "beans: cool { hi }")
    }

    func testArgument() {
        GQLNode("cool", alias: "beans") {
            "hi"
        }
        .withArgument("cool", value: "beans")
        .withArgument("age", value: 29)
        .withArgument("name", value: nil as String?)
        .withArgument("var", variableName: "var")
        .withArgument("age", value: 30)
        .withArgument("var", variableName: "iable")
        .serialize(to: &serializer)

        let compare =
            #"beans: cool"# +
            #"(age: 30, cool: "beans", name: null, var: $iable) "# +
            #"{ hi }"#

        XCTAssertEqual(graphQL, compare)
        XCTAssertEqual(variables.count, 0)
    }

    func testNest() {
        let variable = GQLVariable(name: "message", value: "hello")
        GQLNode("root") {
            "hi"
            GQLNode("parent") {
                "hi"
                GQLNode("beans") {
                    "hi"
                }
                .withArgument("age", value: 40)
                GQLNode("cool") {
                    "hi"
                }
                .withArgument("var", variable: variable)
            }
            .withArgument("age", value: 29)
        }
        .withArgument("var", variableName: "var")
        .serialize(to: &serializer)

        let compare =
            #"root(var: $var) { "# +
            #"hi parent(age: 29) { "# +
            #"hi beans(age: 40) { hi } "# +
            #"cool(var: $message) { hi } } }"#

        XCTAssertEqual(graphQL, compare)
        XCTAssertEqual(variables.count, 1)
    }

    func testFragments() {
        let f1 = Frag1.asFragment()
        let f4 = GQLFragment(name: "cool", type: "Beans") {
            "just"
            "do"
            "it"
        }

        GQLNode("root") {
            "hi"
            f1
            f4
        }
        .serialize(to: &serializer)

        let compare =
            #"root { "# +
            #"hi ...frag1 ...cool }"#

        XCTAssertEqual(graphQL, compare)
        XCTAssertEqual(fragments.count, 2)
    }

    static var allTests = [
        ("testSimple", testSimple),
        ("testAlias", testAlias),
        ("testArgument", testArgument),
        ("testNest", testNest),
        ("testFragments", testFragments),
    ]
}
