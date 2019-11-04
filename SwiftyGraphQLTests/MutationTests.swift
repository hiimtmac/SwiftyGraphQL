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
        let node = GraphQLNode.node(name: "allNodes", [GraphQLNode.attributes(["hi", "ok"])])
        let mutation = GraphQLQuery(mutation: GraphQLMutation(title: "testMutation", parameters: ["thing": "ok"]), returning: node)
        let compare = #"mutation { testMutation(thing: "ok") { allNodes: allNodes { hi ok } } } "#
        XCTAssertEqual(mutation.query, compare)
    }

    func testWithFragment() {
        let node = GraphQLNode.node(name: "allNodes", [GraphQLNode.fragment(Frag2.self)])
        let mutation = GraphQLQuery(mutation: GraphQLMutation(title: "testMutation", parameters: ["thing": "ok"]), returning: node)
        let compare = #"mutation { testMutation(thing: "ok") { allNodes: allNodes { ...frag2 } } } fragment frag2 on Frag2 { address birthday }"#
        XCTAssertEqual(mutation.query, compare)
    }
    
    func testAdvanced() {
        let frag1 = GraphQLNode.node(label: "allFrag1s", name: "frag1", parameters: GraphQLParameters(["since": 20]), [.fragment(Frag1.self)])
        let frag2 = GraphQLNode.node(name: "frag2", [.fragment(Frag2.self)])
        
        let node = GraphQLNode.node(name: "myQuery", [frag1, frag2, .attributes(["thing1", "thing2"])])
        let mutation = GraphQLQuery(mutation: GraphQLMutation(title: "testMutation", parameters: ["thing": "ok"]), returning: node)
        let compare = #"mutation { testMutation(thing: "ok") { myQuery: myQuery { allFrag1s: frag1(since: 20) { ...fragment1 } frag2: frag2 { ...frag2 } thing1 thing2 } } } fragment frag2 on Frag2 { address birthday } fragment fragment1 on Fragment1 { age name }"#
        XCTAssertEqual(mutation.query, compare)
    }
    
    func testWithArray() {
        let one = GraphQLNode.node(name: "one", [.fragment(Frag1.self)])
        let two = GraphQLNode.node(name: "two", [.attributes(["no", "maybe"]), .fragment(Frag2.self)])
        
        let mutation = GraphQLQuery(mutation: GraphQLMutation(title: "testMutation", parameters: ["thing": "ok"]), returning: [one, two])
        let compare = #"mutation { testMutation(thing: "ok") { one: one { ...fragment1 } two: two { no maybe ...frag2 } } } fragment frag2 on Frag2 { address birthday } fragment fragment1 on Fragment1 { age name }"#
        XCTAssertEqual(mutation.query, compare)
    }
    
    func testWithArrayWithEmptyNode() {
        let one = GraphQLNode.node(name: "one", [])
        let two = GraphQLNode.node(name: "two", [.attributes(["no", "maybe"]), .fragment(Frag2.self)])
        
        let mutation = GraphQLQuery(mutation: GraphQLMutation(title: "testMutation", parameters: ["thing": "ok"]), returning: [one, two])
        let compare = #"mutation { testMutation(thing: "ok") { one: one two: two { no maybe ...frag2 } } } fragment frag2 on Frag2 { address birthday }"#
        XCTAssertEqual(mutation.query, compare)
    }
    
    func testWithArrayWithMutationObject() {
        let one = GraphQLNode.node(name: "one", [])
        let two = GraphQLNode.node(name: "two", [.attributes(["no", "maybe"]), .fragment(Frag2.self)])
        let mutation = GraphQLMutation(title: "testMutation", parameters: GraphQLParameters(["thing": "ok"]))
        
        let graphmutation = GraphQLQuery(mutation: mutation, returning: [one, two])
        let compare = #"mutation { testMutation(thing: "ok") { one: one two: two { no maybe ...frag2 } } } fragment frag2 on Frag2 { address birthday }"#
        XCTAssertEqual(graphmutation.query, compare)
    }
    
    func testWithVariables() throws {
        let node = GraphQLNode.node(name: "allNodes", [GraphQLNode.attributes(["hi", "ok"])])
        let var1 = GraphQLVariable(value: 8)
        let var2 = GraphQLVariable(value: nil, defaultValue: false)
        let val: Bool? = nil
        let var3 = GraphQLVariable(value: val)
        let variables = GraphQLVariables(["var1": var1, "var2": var2, "var3": var3])
        
        let mutation = GraphQLQuery(mutation: GraphQLMutation(title: "testMutation", parameters: ["thing": "ok"]), returning: node, variables: variables)
        
        let encoded = try JSONEncoder().encode(mutation)
        let strComp = String(data: encoded, encoding: .utf8)?.dropFirst().dropLast()
        XCTAssertEqual(strComp, "\"query\":\"mutation($var1: Integer!, $var2: Boolean = false, $var3: Boolean) { testMutation(thing: \\\"ok\\\") { allNodes: allNodes { hi ok } } } \",\"variables\":{\"var2\":false,\"var1\":8}")
    }
}
