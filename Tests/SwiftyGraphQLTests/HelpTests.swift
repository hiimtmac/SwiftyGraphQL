//
//  File.swift
//  
//
//  Created by Taylor McIntyre on 2020-09-29.
//

import XCTest
@testable import SwiftyGraphQL

class HelpTests: XCTestCase {
    
    // https://github.com/hiimtmac/SwiftyGraphQL/issues/26
    func testHelp26() throws {
        let usernameVar: GQLVariable = "tmac"
        let slugVar: GQLVariable = "swifty-graphql"
        
        let query = GQLQuery("CodaPlayerItem") {
            GQLNode("cloudcastLookup") {
                "__typename"
                "id"
                GQLNode("streamInfo") {
                    "__typename"
                    "dashUrl"
                    "hlsUrl"
                    "url"
                }
                GQLNode("picture") {
                    "__typename"
                    "urlRoot"
                }
                "name"
                GQLNode("owner") {
                    "__typename"
                    "displayName"
                }
            }
            .withVariable(named: "lookup", variables: ["username": "username", "slug": "slug"])
        }
        .withVariables(["username": usernameVar, "slug": slugVar])
        
        struct Decode: Decodable {
            let query: String
            let variables: Variables
            
            struct Variables: Decodable {
                let username: String
                let slug: String
            }
        }
        
        XCTAssertEqual(query.gqlQueryWithFragments, #"query CodaPlayerItem($slug: String!, $username: String!) { cloudcastLookup(lookup: { slug: $slug, username: $username }) { __typename id name owner { __typename displayName } picture { __typename urlRoot } streamInfo { __typename dashUrl hlsUrl url } } }"#)
        
        let encoded = try JSONEncoder().encode(query)
        let decoded = try JSONDecoder().decode(Decode.self, from: encoded)
        XCTAssertEqual(decoded.variables.username, "tmac")
        XCTAssertEqual(decoded.variables.slug, "swifty-graphql")
    }
}
