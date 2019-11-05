//
//  GraphQLTests.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2019-11-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import XCTest
@testable import SwiftyGraphQL

class GraphQLTests: XCTestCase {
    
    // https://graphql.org/learn/queries/#fields
    func testFields1() {
        let node = GraphQLNode.node(name: "hero", [
            .attributes(["name"])
        ])
        let compare = #"query { hero { name } }"#
        XCTAssertEqual(GraphQLQuery(query: node).query, compare)
    }
    
    func testFields2() {
        let node = GraphQLNode.node(name: "hero", [
            .node(name: "friends", [
                .attributes(["name"])
            ]),
            .attributes(["name"])
        ])
        let compare = #"query { hero { friends { name } name } }"#
        XCTAssertEqual(GraphQLQuery(query: node).query, compare)
    }

    // https://graphql.org/learn/queries/#arguments
    func testArguments1() {
        let node = GraphQLNode.node(name: "human", arguments: ["id":"1000"], [
            .attributes(["name","height"])
        ])
        let compare = #"query { human(id: "1000") { height name } }"#
        XCTAssertEqual(GraphQLQuery(query: node).query, compare)
    }
    
    func testArguments2() {
        let node = GraphQLNode.node(name: "human", arguments: ["id":"1000"], [
            .attributes(["name"]),
            .node(name: "height", arguments: ["unit":"FOOT"])
        ])
        
        let compare = #"query { human(id: "1000") { name height(unit: "FOOT") } }"#
        XCTAssertEqual(GraphQLQuery(query: node).query, compare)
    }
    
    // https://graphql.org/learn/queries/#aliases
    func testAliases() {
        let node1 = GraphQLNode.node(name: "hero", alias: "empireHero", arguments: ["episode": "EMPIRE"], [
            .attributes(["name"])
        ])
        
        let node2 = GraphQLNode.node(name: "hero", alias: "jediHero", arguments: ["episode": "JEDI"], [
            .attributes(["name"])
        ])
        
        let nodes = [node1, node2]
        let compare = #"query { empireHero: hero(episode: "EMPIRE") { name } jediHero: hero(episode: "JEDI") { name } }"#
        
        XCTAssertEqual(GraphQLQuery(query: nodes).query, compare)
    }
    
    // https://graphql.org/learn/queries/#fragments
    func testFragments1() {
        struct Character: GraphQLFragment {
            static var fragmentName: String { "comparisonFields" }
            static var fragmentContent: GraphQLRepresentable {
                let attributes = GraphQLNode.attributes(["appearsIn", "name"])
                let friends = GraphQLNode.node(name: "friends", [
                    .attributes(["name"])
                ])
                return [attributes, friends]
            }
        }
        
        let node1 = GraphQLNode.node(name: "hero", alias: "leftComparison", arguments: ["episode": "EMPIRE"], [
            .fragment(Character.self)
        ])
        let node2 = GraphQLNode.node(name: "hero", alias: "rightComparison", arguments: ["episode": "JEDI"], [
            .fragment(Character.self)
        ])
        
        let compare = #"query { leftComparison: hero(episode: "EMPIRE") { ...comparisonFields } rightComparison: hero(episode: "JEDI") { ...comparisonFields } } fragment comparisonFields on Character { appearsIn name friends { name } }"#
        
        XCTAssertEqual(GraphQLQuery(query: [node1, node2]).query, compare)
    }
    
    func testFragments2() {
        struct Character: GraphQLFragment {
            static var entityName: String { "Character" }
            static var fragmentName: String { "comparisonFields" }
            static var fragmentContent: GraphQLRepresentable {
                let attributes = GraphQLNode.attributes(["name"])
                let friends = GraphQLNode.node(name: "friendsConnection", arguments: ["first": GraphQLVariable(name: "first", value: "first")], [
                    .attributes(["totalCount"]),
                    .node(name: "edges", [
                        .node(name: "node", [
                            .attributes(["name"])
                        ])
                    ])
                ])
                return [attributes, friends]
            }
        }
        
        let node1 = GraphQLNode.node(name: "hero", alias: "leftComparison", arguments: ["episode": "EMPIRE"], [
            .fragment(Character.self)
        ])
        let node2 = GraphQLNode.node(name: "hero", alias: "rightComparison", arguments: ["episode": "JEDI"], [
            .fragment(Character.self)
        ])
        
        let compare = #"query HeroComparison($first: Int) { leftComparison: hero(episode: "EMPIRE") { ...comparisonFields } rightComparison: hero(episode: "JEDI") { ...comparisonFields } } fragment comparisonFields on Character { name friendsConnection(first: $first) { totalCount edges { node { name } } } }"#
        
        let first = GraphQLVariable(name: "first", value: 8)
        XCTAssertEqual(GraphQLQuery(query: [node1, node2], variables: [first], operationName: "HeroComparison").query, compare)
    }
    
    // https://graphql.org/learn/queries/#operation-name
    func testOperationName() {
        let node = GraphQLNode.node(name: "hero", [
            .attributes(["name"]),
            .node(name: "friends", [
                .attributes(["name"])
            ])
        ])
        
        let compare = #"query HeroNameAndFriends { hero { name friends { name } } }"#
        XCTAssertEqual(GraphQLQuery(query: node, operationName: "HeroNameAndFriends").query, compare)
    }
    
    // https://graphql.org/learn/queries/#variables
    func testVariables1() throws {
        let arg = GraphQLVariable(name: "episode", value: "JEDI")
        
        let node = GraphQLNode.node(name: "hero", arguments: ["episode": arg], [
            .attributes(["name"]),
            .node(name: "friends", [
                .attributes(["name"])
            ])
        ])
        
        let query = GraphQLQuery(query: node, variables: [arg], operationName: "HeroNameAndFriends")
        let compare = #"query HeroNameAndFriends($episode: String) { hero(episode: $episode) { name friends { name } } }"#
        
        struct Decode: Decodable {
            let query: String
            let variables: Variables
            
            struct Variables: Decodable {
                let episode: String
            }
        }
        
        let encoded = try JSONEncoder().encode(query)
        let decoded = try JSONDecoder().decode(Decode.self, from: encoded)
        XCTAssertEqual(decoded.query, compare)
        XCTAssertEqual(decoded.variables.episode, "JEDI")
    }
    
    // https://graphql.org/learn/queries/#default-variables
    func testVariable2() throws {
        let arg = GraphQLVariable(name: "episode", value: nil, default: "JEDI")
        
        let node = GraphQLNode.node(name: "hero", arguments: ["episode": arg], [
            .attributes(["name"]),
            .node(name: "friends", [
                .attributes(["name"])
            ])
        ])
        
        let query = GraphQLQuery(query: node, variables: [arg], operationName: "HeroNameAndFriends")
        let compare = #"query HeroNameAndFriends($episode: String) { hero(episode: $episode) { name friends { name } } }"#
        
        struct Decode: Decodable {
            let query: String
            let variables: Variables
            
            struct Variables: Decodable {
                let episode: String
            }
        }
        
        let encoded = try JSONEncoder().encode(query)
        let decoded = try JSONDecoder().decode(Decode.self, from: encoded)
        XCTAssertEqual(decoded.query, compare)
        XCTAssertEqual(decoded.variables.episode, "JEDI")
    }
    
    // https://graphql.org/learn/queries/#directives
    func testDirectives() throws {
        let arg1 = GraphQLVariable(name: "episode", value: "JEDI")
        let arg2 = GraphQLVariable(name: "withFriends", value: false)
        
        let node = GraphQLNode.node(name: "hero", arguments: ["episode": arg1], [
            .attributes(["name"]),
            .node(name: "friends", directive: .include(if: arg2), [
                .attributes(["name"])
            ])
        ])
        
        let query = GraphQLQuery(query: node, variables: [arg1, arg2], operationName: "HeroNameAndFriends")
        let compare = #"query HeroNameAndFriends($episode: String, $withFriends: Boolean) { hero(episode: $episode) { name friends @include(if: $withFriends) { name } } }"#
        
        struct Decode: Decodable {
            let query: String
            let variables: Variables
            
            struct Variables: Decodable {
                let episode: String
                let withFriends: Bool
            }
        }
        
        let encoded = try JSONEncoder().encode(query)
        let decoded = try JSONDecoder().decode(Decode.self, from: encoded)
        XCTAssertEqual(decoded.query, compare)
        XCTAssertEqual(decoded.variables.episode, "JEDI")
        XCTAssertEqual(decoded.variables.withFriends, false)
    }
    
    // https://graphql.org/learn/queries/#mutations
    func testMutation() throws {
        struct ReviewInput: GraphQLVariableRepresentable, Decodable {
            let stars = 5
            let commentary = "This is a great movie!"
        }
        
        let episode = GraphQLVariable(name: "ep", value: "JEDI")
        let review = GraphQLVariable(name: "review", value: ReviewInput())
        
        let node = GraphQLNode.node(name: "createReview", arguments: ["episode": episode, "review": review], [
            .attributes(["stars","commentary"])
        ])
        
        let query = GraphQLQuery(mutation: node, variables: [episode, review], operationName: "CreateReviewForEpisode")
        let compare = #"mutation CreateReviewForEpisode($ep: String, $review: ReviewInput) { createReview(episode: $ep, review: $review) { commentary stars } }"#
        
        struct Decode: Decodable {
            let query: String
            let variables: Variables
            
            struct Variables: Decodable {
                let ep: String
                let review: ReviewInput
            }
        }
        
        let encoded = try JSONEncoder().encode(query)
        let decoded = try JSONDecoder().decode(Decode.self, from: encoded)
        XCTAssertEqual(decoded.query, compare)
        XCTAssertEqual(decoded.variables.ep, "JEDI")
        XCTAssertEqual(decoded.variables.review.stars, 5)
        XCTAssertEqual(decoded.variables.review.commentary, "This is a great movie!")
    }
    
    // https://graphql.org/learn/queries/#inline-fragments
    func _testInlineFragments() {
    
    }
}
