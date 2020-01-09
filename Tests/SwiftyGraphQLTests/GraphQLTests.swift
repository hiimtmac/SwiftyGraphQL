//
//  BuilderTests.swift
//  SwiftyGraphQLTests
//
//  Created by Taylor McIntyre on 2020-01-07.
//  Copyright © 2020 hiimtmac. All rights reserved.
//

import XCTest
@testable import SwiftyGraphQL

class GraphQLTests: XCTestCase {
    
    // https://graphql.org/learn/queries/#fields
    func testExample1() {
        let query = GQLQuery {
            GQLNode("hero") {
                "name"
            }
        }
        
        XCTAssertEqual(query.gqlQueryString, #"query { hero { name } }"#)
        XCTAssertEqual(query.gqlQueryWithFragments, #"query { hero { name } }"#)
    }
    
    func testExample2() {
        let query = GQLQuery {
            GQLNode("hero") {
                "name"
                GQLNode("friends") {
                    "name"
                }
            }
        }
        
        XCTAssertEqual(query.gqlQueryString, #"query { hero { friends { name } name } }"#)
        XCTAssertEqual(query.gqlQueryWithFragments, #"query { hero { friends { name } name } }"#)
    }
    
    // https://graphql.org/learn/queries/#arguments
    func testExample3() {
        let query = GQLQuery {
            GQLNode("human") {
                "name"
                GQLNode("height")
                    .withArgument(named: "unit", value: "FOOT")
            }
            .withArgument(named: "id", value: "1000")
        }
        
        XCTAssertEqual(query.gqlQueryString, #"query { human(id: "1000") { height(unit: "FOOT") name } }"#)
        XCTAssertEqual(query.gqlQueryWithFragments, #"query { human(id: "1000") { height(unit: "FOOT") name } }"#)
    }
    
    // https://graphql.org/learn/queries/#aliases
    func testExample4() {
        let query = GQLQuery {
            GQLNode("hero", alias: "empireHero") {
                "name"
            }
            .withArgument(named: "episode", value: "EMPIRE")
            GQLNode("hero", alias: "jediHero") {
                "name"
            }
            .withArgument(named: "episode", value: "JEDI")
        }
        
        XCTAssertEqual(query.gqlQueryString, #"query { empireHero: hero(episode: "EMPIRE") { name } jediHero: hero(episode: "JEDI") { name } }"#)
        XCTAssertEqual(query.gqlQueryWithFragments, #"query { empireHero: hero(episode: "EMPIRE") { name } jediHero: hero(episode: "JEDI") { name } }"#)
    }
    
    // https://graphql.org/learn/queries/#fragments
    func testExample5() {
        struct Character: GQLFragmentable {
            static let fragmentName = "comparisonFields"
            
            enum CodingKeys: String, CodingKey, CaseIterable {
                case name
            }
            
            static var gqlContent: GraphQL {
                GQLAttributes {
                    "name"
                    "appearsIn"
                    GQLNode("friends") {
                        "name"
                    }
                }
            }
        }
        
        let query = GQLQuery {
            GQLNode("hero", alias: "leftComparison") {
                GQLFragment(Character.self)
            }
            .withArgument(named: "episode", value: "EMPIRE")
            GQLNode("hero", alias: "rightComparison") {
                GQLFragment(Character.self)
            }
            .withArgument(named: "episode", value: "JEDI")
        }
        
        XCTAssertEqual(query.gqlQueryString, #"query { leftComparison: hero(episode: "EMPIRE") { ...comparisonFields } rightComparison: hero(episode: "JEDI") { ...comparisonFields } }"#)
        XCTAssertEqual(query.gqlFragmentString, #"fragment comparisonFields on Character { appearsIn friends { name } name }"#)
        XCTAssertEqual(query.gqlQueryWithFragments, #"query { leftComparison: hero(episode: "EMPIRE") { ...comparisonFields } rightComparison: hero(episode: "JEDI") { ...comparisonFields } } fragment comparisonFields on Character { appearsIn friends { name } name }"#)
    }
    
    func testExample6() throws {
        struct Character: GQLFragmentable, GQLAttributable {
            static let fragmentName = "comparisonFields"
            
            enum CodingKeys: String, CodingKey, CaseIterable {
                case name
            }
            
            static var gqlContent: GraphQL {
                GQLAttributes {
                    "name"
                    GQLNode("friendsConnection") {
                        "totalCount"
                        GQLNode("edges") {
                            GQLNode("node") {
                                "name"
                            }
                        }
                    }
                    .withVariable(named: "first", variableName: "first")
                }
            }
        }
        
        let query = GQLQuery("HeroComparison") {
            GQLNode("hero", alias: "leftComparison") {
                GQLFragment(Character.self)
            }
            .withArgument(named: "episode", value: "EMPIRE")
            GQLNode("hero", alias: "rightComparison") {
                GQLFragment(Character.self)
            }
            .withArgument(named: "episode", value: "JEDI")
        }
        .withVariable(named: "first", value: 5 as Int?)
        
        XCTAssertEqual(query.gqlQueryString, #"query HeroComparison($first: Int) { leftComparison: hero(episode: "EMPIRE") { ...comparisonFields } rightComparison: hero(episode: "JEDI") { ...comparisonFields } }"#)
        XCTAssertEqual(query.gqlFragmentString, #"fragment comparisonFields on Character { friendsConnection(first: $first) { edges { node { name } } totalCount } name }"#)
        XCTAssertEqual(query.gqlQueryWithFragments, #"query HeroComparison($first: Int) { leftComparison: hero(episode: "EMPIRE") { ...comparisonFields } rightComparison: hero(episode: "JEDI") { ...comparisonFields } } fragment comparisonFields on Character { friendsConnection(first: $first) { edges { node { name } } totalCount } name }"#)
        
        struct Decode: Decodable {
            let query: String
            let variables: Variables
            
            struct Variables: Decodable {
                let first: Int
            }
        }
        let encoded = try JSONEncoder().encode(query)
        let decoded = try JSONDecoder().decode(Decode.self, from: encoded)
        XCTAssertEqual(decoded.variables.first, 5)
    }

    // https://graphql.org/learn/queries/#operation-name
    func testExample7() {
        let query = GQLQuery("HeroNameAndFriends") {
            GQLNode("hero") {
                "name"
                GQLNode("friends") {
                    "name"
                }
            }
        }
        
        XCTAssertEqual(query.gqlQueryString, #"query HeroNameAndFriends { hero { friends { name } name } }"#)
        XCTAssertEqual(query.gqlQueryWithFragments, #"query HeroNameAndFriends { hero { friends { name } name } }"#)
    }
    
    // https://graphql.org/learn/queries/#variables
    func testExample8() throws {
        enum Episode: String, GQLVariable, Codable {
            case jedi = "JEDI"
        }
        
        let query = GQLQuery("HeroNameAndFriends") {
            GQLNode("hero") {
                "name"
                GQLNode("friends") {
                    "name"
                }
            }
            .withVariable(named: "episode", variableName: "episode")
        }
        .withVariable(named: "episode", value: Episode.jedi as Episode?)
        
        XCTAssertEqual(query.gqlQueryString, #"query HeroNameAndFriends($episode: Episode) { hero(episode: $episode) { friends { name } name } }"#)
        XCTAssertEqual(query.gqlQueryWithFragments, #"query HeroNameAndFriends($episode: Episode) { hero(episode: $episode) { friends { name } name } }"#)
        
        struct Decode: Decodable {
            let query: String
            let variables: Variables
            
            struct Variables: Decodable {
                let episode: Episode
            }
        }
        let encoded = try JSONEncoder().encode(query)
        let decoded = try JSONDecoder().decode(Decode.self, from: encoded)
        XCTAssertEqual(decoded.variables.episode.rawValue, "JEDI")
    }
    
    // https://graphql.org/learn/queries/#default-variables
    func testExample9() {
        // this example doesnt make sense, you would just provide a default value with the optional
        enum Episode: String, GQLVariable, Codable {
            case jedi = "JEDI"
        }
        
        let optional: Episode? = nil
        
        let _ = GQLQuery("HeroNameAndFriends") {
            GQLNode("hero") {
                "name"
            }
        }
        .withVariable(named: "episode", value: optional ?? .jedi)
    }
    
    // https://graphql.org/learn/queries/#directives
    func testExample10() throws {
        enum Episode: String, GQLVariable, Decodable {
            case jedi = "JEDI"
        }
        
        let query = GQLQuery("HeroNameAndFriends") {
            GQLNode("hero") {
                "name"
                GQLNode("friends") {
                    "name"
                }
                .withDirective(IncludeDirective(if: "withFriends"))
            }
            .withVariable(named: "episode", variableName: "episode")
        }
        .withVariable(named: "episode", value: Episode.jedi as Episode?)
        .withVariable(named: "withFriends", value: false as Bool?)
        
        XCTAssertEqual(query.gqlQueryString, #"query HeroNameAndFriends($episode: Episode, $withFriends: Boolean) { hero(episode: $episode) { friends @include(if: $withFriends) { name } name } }"#)
        XCTAssertEqual(query.gqlQueryWithFragments, #"query HeroNameAndFriends($episode: Episode, $withFriends: Boolean) { hero(episode: $episode) { friends @include(if: $withFriends) { name } name } }"#)
        
        struct Decode: Decodable {
            let query: String
            let variables: Variables
            
            struct Variables: Decodable {
                let episode: Episode
                let withFriends: Bool
            }
        }
        let encoded = try JSONEncoder().encode(query)
        let decoded = try JSONDecoder().decode(Decode.self, from: encoded)
        XCTAssertEqual(decoded.variables.episode.rawValue, "JEDI")
        XCTAssertEqual(decoded.variables.withFriends, false)
    }
    
    // https://graphql.org/learn/queries/#mutations
    func testExample11() throws {
        struct ReviewInput: GQLVariable, Decodable {
            let stars: Int
            let commentary: String
            
            static var stub: Self { .init(stars: 5, commentary: "This is a great movie!") }
        }
        
        enum Episode: String, GQLVariable, Decodable {
            case jedi = "JEDI"
        }
        
        let mutation = GQLMutation("CreateReviewForEpisode") {
            GQLNode("createReview") {
                "stars"
                "commentary"
            }
            .withVariable(named: "episode", variableName: "ep")
            .withVariable(named: "review", variableName: "review")
        }
        .withVariable(named: "ep", value: Episode.jedi)
        .withVariable(named: "review", value: ReviewInput.stub)
        
        XCTAssertEqual(mutation.gqlQueryString, #"mutation CreateReviewForEpisode($ep: Episode!, $review: ReviewInput!) { createReview(episode: $ep, review: $review) { commentary stars } }"#)
        XCTAssertEqual(mutation.gqlQueryWithFragments, #"mutation CreateReviewForEpisode($ep: Episode!, $review: ReviewInput!) { createReview(episode: $ep, review: $review) { commentary stars } }"#)
        
        struct Decode: Decodable {
            let query: String
            let variables: Variables
            
            struct Variables: Decodable {
                let ep: Episode
                let review: ReviewInput
            }
        }
        let encoded = try JSONEncoder().encode(mutation)
        let decoded = try JSONDecoder().decode(Decode.self, from: encoded)
        XCTAssertEqual(decoded.variables.ep.rawValue, "JEDI")
        XCTAssertEqual(decoded.variables.review.stars, 5)
        XCTAssertEqual(decoded.variables.review.commentary, "This is a great movie!")
    }
    
    func testAdvancedExample() throws {
        struct T1: GQLVariable, Decodable, Equatable {
            let float: Float
            let int: Int
            let string: String
        }
        
        struct T2: GQLVariable, Decodable, Equatable {
            let nested: NestedT2
            let temperature: Double
            let weather: String?
            
            struct NestedT2: Codable, Equatable {
                let name: String
                let active: Bool
            }
        }
        
        struct MyFragment: GQLFragmentable, GQLAttributable {
            enum CodingKeys: String, CodingKey, CaseIterable {
                case p1
                case p2
                case p3 = "hithere"
            }
            
            static var gqlContent: GraphQL {
                GQLAttributes(Self.self)
            }
        }
        
        let t1 = T1(float: 1.5, int: 1, string: "cool name")
        let t2 = T2(nested: .init(name: "taylor", active: true), temperature: 2.5, weather: "pretty great")
        let rev: String? = "this is great"
        
        let query = GQLQuery("MyCoolQuery") {
            GQLNode("first", alias: "realFirst") {
                "hello"
                "there"
                GQLAttributes(MyFragment.self)
                GQLFragment(MyFragment.self)
                GQLNode("inner") {
                    GQLAttributes(MyFragment.self) { t in
                        t.p1
                        t.p2
                    }
                    GQLNode("cool")
                        .withDirective(SkipDirective(if: "cool"))
                    GQLNode("supernested") {
                        GQLFragment(MyFragment.self)
                    }
                    .withVariable(named: "t2", variableName: "type2")
                }
                .withArgument(named: "name", value: "taylor")
                .withArgument(named: "age", value: 666)
                .withArgument(named: "fraction", value: 2.59)
                .withVariable(named: "rev", variableName: "review")
            }
            .withVariable(named: "t1", variableName: "type1")
        }
        .withVariable(named: "type1", value: t1)
        .withVariable(named: "type2", value: t2)
        .withVariable(named: "review", value: rev)
        .withVariable(named: "cool", value: true)
        
        struct Decode: Decodable {
            let query: String
            let variables: Variables
            
            struct Variables: Decodable {
                let type1: T1
                let review: String
                let type2: T2
                let cool: Bool
            }
        }
        
        let encoded = try JSONEncoder().encode(query)
        let decoded = try JSONDecoder().decode(Decode.self, from: encoded)
        XCTAssertEqual(decoded.variables.type1, t1)
        XCTAssertEqual(decoded.variables.type2, t2)
        XCTAssertEqual(decoded.variables.review, rev)
        XCTAssertEqual(decoded.query, """
        query MyCoolQuery($cool: Boolean!, $review: String, $type1: T1!, $type2: T2!) { realFirst: first(t1: $type1) { ...myfragment hello hithere p1 p2 inner(age: 666, fraction: 2.59, name: "taylor", rev: $review) { cool @skip(if: $cool) p1 p2 supernested(t2: $type2) { ...myfragment } } there } } fragment myfragment on MyFragment { hithere p1 p2 }
        """)
    }
}