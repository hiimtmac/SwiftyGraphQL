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
        let node = GraphQLNode.node(name: "testMutation", arguments: ["thing": "ok"], [
            .node(name: "allNodes", [
                .attributes(["hi", "ok"])
            ])
        ])
        let mutation = GraphQLQuery(mutation: node)
        let compare = #"mutation { testMutation(thing: "ok") { allNodes { hi ok } } }"#
        XCTAssertEqual(mutation.query, compare)
    }

    func testWithFragment() {
        let node = GraphQLNode.node(name: "testMutation", arguments: ["thing": "ok"], [
            .node(name: "allNodes", [
                .fragment(Frag2.self)
            ])
        ])
        let mutation = GraphQLQuery(mutation: node)
        let compare = #"mutation { testMutation(thing: "ok") { allNodes { ...frag2 } } } fragment frag2 on Frag2 { address birthday }"#
        XCTAssertEqual(mutation.query, compare)
    }
    
    func testAdvanced() {
        let node = GraphQLNode.node(name: "testMutation", arguments: ["thing": "ok"], [
            .node(name: "myQuery", [
                .node(name: "frag1", alias: "allFrag1s", arguments: ["since": 20], [
                    .fragment(Frag1.self)
                ]),
                .node(name: "frag2", [
                    .fragment(Frag2.self)
                ]),
                .attributes(["thing1","thing2"])
            ])
        ])
        
        let mutation = GraphQLQuery(mutation: node)
        let compare = #"mutation { testMutation(thing: "ok") { myQuery { allFrag1s: frag1(since: 20) { ...fragment1 } frag2 { ...frag2 } thing1 thing2 } } } fragment frag2 on Frag2 { address birthday } fragment fragment1 on Fragment1 { age name }"#
        XCTAssertEqual(mutation.query, compare)
    }
    
    func testWithArray() {
        let node = GraphQLNode.node(name: "testMutation", arguments: ["thing": "ok"], [
            .node(name: "one", [
                .fragment(Frag1.self)
            ]),
            .node(name: "two", [
                .attributes(["no", "maybe"]),
                .fragment(Frag2.self)
            ])
        ])
        
        let mutation = GraphQLQuery(mutation: node)
        let compare = #"mutation { testMutation(thing: "ok") { one { ...fragment1 } two { maybe no ...frag2 } } } fragment frag2 on Frag2 { address birthday } fragment fragment1 on Fragment1 { age name }"#
        XCTAssertEqual(mutation.query, compare)
    }
    
    func testWithArrayWithEmptyNode() {
        let node = GraphQLNode.node(name: "testMutation", arguments: ["thing": "ok"], [
            .node(name: "one", []),
            .node(name: "two", [
                .attributes(["no", "maybe"]),
                .fragment(Frag2.self)
            ])
        ])
        
        let mutation = GraphQLQuery(mutation: node)
        let compare = #"mutation { testMutation(thing: "ok") { one two { maybe no ...frag2 } } } fragment frag2 on Frag2 { address birthday }"#
        XCTAssertEqual(mutation.query, compare)
    }
    
    /*
    func testWithVariables() throws {
        let node = GraphQLNode.node(name: "allNodes", [GraphQLNode.attributes(["hi", "ok"])])
        let var1 = GraphQLVariable(value: 8)
        let var2 = GraphQLVariable(value: nil, defaultValue: false)
        let val: Bool? = nil
        let var3 = GraphQLVariable(value: val)
        let variables = GraphQLVariables(["var1": var1, "var2": var2, "var3": var3])
        
        let mutation = GraphQLQuery(mutation: GraphQLMutation(title: "testMutation", arguments: ["thing": "ok"]), returning: node, variables: variables)
        
        let encoded = try JSONEncoder().encode(mutation)
        let strComp = String(data: encoded, encoding: .utf8)?.dropFirst().dropLast()
        XCTAssertEqual(strComp, "\"query\":\"mutation($var1: Integer!, $var2: Boolean = false, $var3: Boolean) { testMutation(thing: \\\"ok\\\") { allNodes: allNodes { hi ok } } } \",\"variables\":{\"var2\":false,\"var1\":8}")
    }
 */
}
