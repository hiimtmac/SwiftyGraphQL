// GraphQLTests.swift
// Copyright © 2022 hiimtmac

import XCTest
@testable import SwiftyGraphQL

class GraphQLTests: BaseTestCase {
    // https://graphql.org/learn/queries/#fields
    func testExample1() {
        GQL {
            GQLNode("hero") {
                "name"
            }
        }
        .serialize(to: &serializer)

        XCTAssertEqual(graphQL, #"query { hero { name } }"#)
        XCTAssert(fragmentQL.isEmpty)
    }

    func testExample2() {
        GQL {
            GQLNode("hero") {
                "name"
                GQLNode("friends") {
                    "name"
                }
            }
        }
        .serialize(to: &serializer)

        XCTAssertEqual(graphQL, #"query { hero { name friends { name } } }"#)
        XCTAssert(fragmentQL.isEmpty)
    }

    // https://graphql.org/learn/queries/#arguments
    func testExample3() {
        GQL {
            GQLNode("human") {
                "name"
                GQLEmpty("height")
                    .withArgument("unit", value: "FOOT")
            }
            .withArgument("id", value: "1000")
        }
        .serialize(to: &serializer)

        XCTAssertEqual(graphQL, #"query { human(id: "1000") { name height(unit: "FOOT") } }"#)
        XCTAssert(fragmentQL.isEmpty)
    }

    // https://graphql.org/learn/queries/#aliases
    func testExample4() {
        GQL {
            GQLNode("hero", alias: "empireHero") {
                "name"
            }
            .withArgument("episode", value: "EMPIRE")
            GQLNode("hero", alias: "jediHero") {
                "name"
            }
            .withArgument("episode", value: "JEDI")
        }
        .serialize(to: &serializer)

        XCTAssertEqual(graphQL, #"query { empireHero: hero(episode: "EMPIRE") { name } jediHero: hero(episode: "JEDI") { name } }"#)
        XCTAssert(fragmentQL.isEmpty)
    }

    // https://graphql.org/learn/queries/#fragments
    func testExample5() {
        struct Character: GQLFragmentable {
            static let fragmentName = "comparisonFields"
            static var graqhQl: GraphQLExpression {
                "name"
                "appearsIn"
                GQLNode("friends") {
                    "name"
                }
            }
        }

        GQL {
            GQLNode("hero", alias: "leftComparison") {
                GQLFragment(Character.self)
            }
            .withArgument("episode", value: "EMPIRE")
            GQLNode("hero", alias: "rightComparison") {
                GQLFragment(Character.self)
            }
            .withArgument("episode", value: "JEDI")
        }
        .serialize(to: &serializer)

        XCTAssertEqual(graphQL, #"query { leftComparison: hero(episode: "EMPIRE") { ...comparisonFields } rightComparison: hero(episode: "JEDI") { ...comparisonFields } }"#)
        XCTAssertEqual(fragmentQL, #"fragment comparisonFields on Character { name appearsIn friends { name } }"#)
    }

    func testExample6() throws {
        struct Character: GQLFragmentable {
            static let fragmentName = "comparisonFields"
            static var graqhQl: GraphQLExpression {
                "name"
                GQLNode("friendsConnection") {
                    "totalCount"
                    GQLNode("edges") {
                        GQLNode("node") {
                            "name"
                        }
                    }
                }
                .withArgument("first", variableName: "first")
            }
        }

        let gql = GQL(name: "HeroComparison") {
            GQLNode("hero", alias: "leftComparison") {
                GQLFragment(Character.self)
            }
            .withArgument("episode", value: "EMPIRE")
            GQLNode("hero", alias: "rightComparison") {
                GQLFragment(Character.self)
            }
            .withArgument("episode", value: "JEDI")
        }
        .withVariable("first", value: 5 as Int?)

        gql.serialize(to: &serializer)

        XCTAssertEqual(graphQL, #"query HeroComparison($first: Int) { leftComparison: hero(episode: "EMPIRE") { ...comparisonFields } rightComparison: hero(episode: "JEDI") { ...comparisonFields } }"#)
        XCTAssertEqual(fragmentQL, #"fragment comparisonFields on Character { name friendsConnection(first: $first) { totalCount edges { node { name } } } }"#)

        struct Decode: Decodable {
            let query: String
            let variables: Variables

            struct Variables: Decodable {
                let first: Int
            }
        }
        let encoded = try JSONEncoder().encode(gql)
        let decoded = try JSONDecoder().decode(Decode.self, from: encoded)
        XCTAssertEqual(decoded.variables.first, 5)
    }

    // https://graphql.org/learn/queries/#operation-name
    func testExample7() {
        GQL(name: "HeroNameAndFriends") {
            GQLNode("hero") {
                "name"
                GQLNode("friends") {
                    "name"
                }
            }
        }
        .serialize(to: &serializer)

        XCTAssertEqual(graphQL, #"query HeroNameAndFriends { hero { name friends { name } } }"#)
        XCTAssert(fragmentQL.isEmpty)
    }

    // https://graphql.org/learn/queries/#variables
    func testExample8() throws {
        enum Episode: String, GraphQLVariableExpression, Codable {
            case jedi = "JEDI"
        }

        let gql = GQL(name: "HeroNameAndFriends") {
            GQLNode("hero") {
                "name"
                GQLNode("friends") {
                    "name"
                }
            }
            .withArgument("episode", variableName: "episode")
        }
        .withVariable("episode", value: Episode.jedi as Episode?)

        gql.serialize(to: &serializer)

        XCTAssertEqual(graphQL, #"query HeroNameAndFriends($episode: Episode) { hero(episode: $episode) { name friends { name } } }"#)
        XCTAssert(fragmentQL.isEmpty)

        struct Decode: Decodable {
            let query: String
            let variables: Variables

            struct Variables: Decodable {
                let episode: Episode
            }
        }
        let encoded = try JSONEncoder().encode(gql)
        let decoded = try JSONDecoder().decode(Decode.self, from: encoded)
        XCTAssertEqual(decoded.variables.episode.rawValue, "JEDI")
    }

    // https://graphql.org/learn/queries/#default-variables
    func testExample9() {
        // this example doesnt make sense, you would just provide a default value with the optional
        enum Episode: String, GraphQLVariableExpression, Codable {
            case jedi = "JEDI"
        }

        let optional: Episode? = nil

        GQL(name: "HeroNameAndFriends") {
            GQLNode("hero") {
                "name"
            }
        }
        .withVariable("episode", value: optional ?? .jedi)
        .serialize(to: &serializer)
    }

    // https://graphql.org/learn/queries/#directives
    func testExample10() throws {
        enum Episode: String, GraphQLVariableExpression, Decodable {
            case jedi = "JEDI"
        }

        let withFriends = GQLVariable(name: "withFriends", value: false as Bool?)

        let gql = GQL(name: "HeroNameAndFriends") {
            GQLNode("hero") {
                "name"
                GQLNode("friends") {
                    "name"
                }
                .includeIf(withFriends)
            }
            .withArgument("episode", variableName: "episode")
        }
        .withVariable("episode", value: Episode.jedi as Episode?)
        .withVariable(withFriends as GQLVariable)

        gql.serialize(to: &serializer)

        XCTAssertEqual(graphQL, #"query HeroNameAndFriends($episode: Episode, $withFriends: Boolean) { hero(episode: $episode) { name friends @include(if: $withFriends) { name } } }"#)
        XCTAssert(fragmentQL.isEmpty)

        struct Decode: Decodable {
            let query: String
            let variables: Variables

            struct Variables: Decodable {
                let episode: Episode
                let withFriends: Bool
            }
        }
        let encoded = try JSONEncoder().encode(gql)
        let decoded = try JSONDecoder().decode(Decode.self, from: encoded)
        XCTAssertEqual(decoded.variables.episode.rawValue, "JEDI")
        XCTAssertEqual(decoded.variables.withFriends, false)
    }

    // https://graphql.org/learn/queries/#mutations
    func testExample11() throws {
        struct ReviewInput: GraphQLVariableExpression, Decodable {
            let stars: Int
            let commentary: String

            static var stub: Self { .init(stars: 5, commentary: "This is a great movie!") }
        }

        enum Episode: String, GraphQLVariableExpression, Decodable {
            case jedi = "JEDI"
        }

        let variable = GQLVariable(name: "ep", value: Episode.jedi)

        let gql = GQL(.mutation, name: "CreateReviewForEpisode") {
            GQLNode("createReview") {
                "stars"
                "commentary"
            }
            .withArgument("episode", variable: variable)
            .withArgument("review", variableName: "review")
        }
        .withVariable(variable)
        .withVariable("review", value: ReviewInput.stub)

        gql.serialize(to: &serializer)

        XCTAssertEqual(graphQL, #"mutation CreateReviewForEpisode($ep: Episode!, $review: ReviewInput!) { createReview(episode: $ep, review: $review) { stars commentary } }"#)
        XCTAssert(fragmentQL.isEmpty)

        struct Decode: Decodable {
            let query: String
            let variables: Variables

            struct Variables: Decodable {
                let ep: Episode
                let review: ReviewInput
            }
        }
        let encoded = try JSONEncoder().encode(gql)
        let decoded = try JSONDecoder().decode(Decode.self, from: encoded)
        XCTAssertEqual(decoded.variables.ep.rawValue, "JEDI")
        XCTAssertEqual(decoded.variables.review.stars, 5)
        XCTAssertEqual(decoded.variables.review.commentary, "This is a great movie!")
    }

    func testAdvancedExample() throws {
        struct T1: GraphQLVariableExpression, Decodable, Equatable {
            let float: Float
            let int: Int
            let string: String
        }

        struct T2: GraphQLVariableExpression, Decodable, Equatable {
            let nested: NestedT2
            let temperature: Double
            let weather: String?

            struct NestedT2: Codable, Equatable {
                let name: String
                let active: Bool
            }
        }

        struct MyFragment: GQLFragmentable, GQLCodable {
            let p1: String
            let p2: String
            let p3: String

            enum CodingKeys: String, CodingKey, CaseIterable {
                case p1
                case p2
                case p3 = "hithere"
            }
        }

        let t1 = T1(float: 1.5, int: 1, string: "cool name")
        let t2 = T2(nested: .init(name: "taylor", active: true), temperature: 2.5, weather: "pretty great")
        let rev: String? = "this is great"

        let gql = GQL(name: "MyCoolQuery") {
            GQLNode("first", alias: "realFirst") {
                "hello"
                "there"
                MyFragment.asFragment()
                GQLNode("inner") {
                    GQLFragment(name: "adhoc", type: "MyFragment") {
                        "p1"
                        "p2"
                    }
                    GQLEmpty("cool")
                        .skipIf("cool")
                    GQLNode("supernested") {
                        GQLFragment(MyFragment.self)
                    }
                    .withArgument("t2", variableName: "type2")
                }
                .withArgument("name", value: "taylor")
                .withArgument("age", value: 666)
                .withArgument("fraction", value: 2.59)
                .withArgument("rev", variableName: "review")
            }
            .withArgument("t1", variableName: "type1")
        }
        .withVariable("type1", value: t1)
        .withVariable("type2", value: t2)
        .withVariable("review", value: rev)
        .withVariable("cool", value: true)

        gql.serialize(to: &serializer)

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

        let encoded = try JSONEncoder().encode(gql)
        let decoded = try JSONDecoder().decode(Decode.self, from: encoded)
        XCTAssertEqual(decoded.variables.type1, t1)
        XCTAssertEqual(decoded.variables.type2, t2)
        XCTAssertEqual(decoded.variables.review, rev)

        let compare = #"query MyCoolQuery($cool: Boolean!, $review: String, $type1: T1!, $type2: T2!) { "# +
            #"realFirst: first(t1: $type1) { "# +
            #"hello there ...myfragment "# +
            #"inner(age: 666, fraction: 2.59, name: "taylor", rev: $review) { "# +
            #"...adhoc cool @skip(if: $cool) supernested(t2: $type2) { "# +
            #"...myfragment } } } } "# +
            #"fragment adhoc on MyFragment { p1 p2 } fragment myfragment on MyFragment { p1 p2 hithere }"#
        XCTAssertEqual(decoded.query, compare)
    }

    static var allTests = [
        ("testExample1", testExample1),
        ("testExampl21", testExample2),
        ("testExampl31", testExample3),
        ("testExampl41", testExample4),
        ("testExampl51", testExample5),
        ("testExampl61", testExample6),
        ("testExampl71", testExample7),
        ("testExampl81", testExample8),
        ("testExampl91", testExample9),
        ("testExample10", testExample10),
        ("testExample11", testExample11),
        ("testAdvancedExample", testAdvancedExample),
    ]
}
