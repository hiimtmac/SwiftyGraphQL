//
//  File.swift
//  
//
//  Created by Taylor McIntyre on 2020-09-29.
//

import XCTest
@testable import SwiftyGraphQL

class HelpTests: BaseTestCase {
    
//    // https://github.com/hiimtmac/SwiftyGraphQL/issues/26
//    func testIssue26() throws {
//        let slug = GQLVariable(name: "slug", value: "swifty-graphql")
//        let username = GQLVariable(name: "username", value: "tmac")
//        
//        let gql = GQL(name: "CodaPlayerItem") {
//            GQLNode("cloudcastLookup") {
//                "__typename"
//                "id"
//                GQLNode("streamInfo") {
//                    "__typename"
//                    "dashUrl"
//                    "hlsUrl"
//                    "url"
//                }
//                GQLNode("picture") {
//                    "__typename"
//                    "urlRoot"
//                }
//                "name"
//                GQLNode("owner") {
//                    "__typename"
//                    "displayName"
//                }
//            }
////            .withArgument("lookup", variableSet: [slug, username])
//        }
//        .withVariable(slug)
//        .withVariable(username)
//        
//        gql.serialize(to: &serializer)
//        
//        struct Variables: Decodable, Equatable {
//            let username: String
//            let slug: String
//        }
//        
//        let compare = #"query CodaPlayerItem($slug: String!, $username: String!) { "# +
//            #"cloudcastLookup(lookup: { slug: $slug, username: $username }) { "# +
//            #"__typename id streamInfo { __typename dashUrl hlsUrl url } "# +
//            #"picture { __typename urlRoot } name "# +
//            #"owner { __typename displayName } } }"#
//        
//        let encoded = try gql.encode()
//        let decoded = try JSONDecoder().decode(TestEncoded<Variables>.self, from: encoded)
//        XCTAssertEqual(decoded, TestEncoded<Variables>(query: compare, variables: .init(username: "swifty-graphql", slug: "tmac")))
//    }
    
    // https://github.com/hiimtmac/SwiftyGraphQL/issues/29
    func testIssue29() {
        let n1: [GQLNode] = []
        let n2: [GQLNode] = []
        let nodes = n1 + n2
        GQL(name: "test") {
            nodes
        }
        .serialize(to: &serializer)
    }
}
