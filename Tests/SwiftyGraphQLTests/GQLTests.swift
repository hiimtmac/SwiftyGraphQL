//
//  File.swift
//  
//
//  Created by Taylor McIntyre on 2020-09-30.
//

import XCTest
import SwiftyGraphQL

class GQLTests: BaseTestCase {
    
    func testSerialize() {
        GQL(.query, name: "cool") {
            GQLNode("node") {
                "hi"
                "there"
            }
            .withArgument("string", value: "hello")
            .withArgument("var", variableName: "var")
        }
        .withVariable("var", value: "message")
        .serialize(to: &serializer)
        
        let compare = "query cool($var: String!) { " +
            #"node(string: "hello", var: $var) { "# +
            "hi there } }"
        
        XCTAssertEqual(graphQL, compare)
        XCTAssertEqual(variables.count, 1)
    }
    
    func testEncode() throws {
        let f = GQLFragment(name: "cool", type: "Beans") {
            "just"
            "do"
            "it"
        }
        
        let gql = GQL(.query, name: "cool") {
            GQLNode("node") {
                f
                "hi"
            }
            .withArgument("string", value: "hello")
            .withArgument("var", variableName: "var")
        }
        .withVariable("var", value: "message")
        
        struct Variables: Decodable, Equatable {
            let `var`: String
        }
        
        let data = try JSONEncoder().encode(gql)
        let decoded = try JSONDecoder().decode(TestEncoded<Variables>.self, from: data)
        
        let compare = #"query cool($var: String!) { "# +
            #"node(string: "hello", var: $var) { "# +
            #"...cool hi } } "# +
            #"fragment cool on Beans { just do it }"#
        XCTAssertEqual(decoded, TestEncoded<Variables>(query: compare, variables: .init(var: "message")))
    }
    
    static var allTests = [
        ("testSerialize", testSerialize),
        ("testEncode", testEncode)
    ]
}
