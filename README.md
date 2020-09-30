# SwiftyGraphQL

[![Platform](https://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](https://developer.apple.com/swift)
[![Swift Version](https://img.shields.io/badge/swift-5.3-green.svg?style=flat)](https://developer.apple.com/swift)

This library helps to make typesafe(er) graphql queries & mutations, for those who are scared of a library that does codegen

## Requirements

- Swift 5.3+
- iOS 11+, macOS 14+

## Installation

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.

```swift
import PackageDescription

let package = Package(
  name: "TestProject",
  dependencies: [
    .package(url: "https://github.com/hiimtmac/SwiftyGraphQL.git", from: "2.0.0")
  ]
)
```

### Cocoapods

```ruby
target 'MyApp' do
  pod 'SwiftyGraphQL', '~> 2.0'
end
```

## Usage

General usage looks as such

```swift
let query = GQL(name: "HeroNameAndFriends") {
    GQLNode("hero") {
        "name"
        "age"
        GQLNode("friends") {
            "name"
            "age"
        }
    }
    .withArgument("episode", variableName: "episode")
}
.withVariable("episode", value: "JEDI")
```

```graphql
query HeroNameAndFriends($episode: Episode) {
  hero(episode: $episode) {
    name
    age
    friends {
      name
      age
    }
  }
}
```

### GQLNode

```swift
let node = GQLNode("Root", alias: "root") {
    GQLNode("sub") {
        "thing1"
        "thing2"
    }
    "thing3"
    "thing4"
    GQLFragment(Object.self)
}
```

```graphql
{
    root: Root {
        sub {
            thing1
            thing2
        }
        thing3
        thing4
        ...object
    }
}

fragment object on Object {
    ... // object attributes
}
```

> Note: Output will be separated by spaces rather than carriage returns

```graphql
{ root: Root { sub { thing1 thing2 } thing3 thing4 ...object } } fragment object on Object { ... // object attributes }
```

#### Alias

Add a node alias in `.init(_ name: String, alias: String? = nil)`. An alias will change the returning json key for that node.

```swift
let node = GQLNode("sub") {
    "thing1"
    "thing2"
}
```

```graphql
sub { thing1 thing2 }
```

```swift
let node = GQLNode("sub", alias: "cool") {
    "thing1"
    "thing2"
}
```

```graphql
cool: sub { thing1 thing2 }
```

#### Arguments

TODO documentation

#### Variables

TODO documentation

#### Directives

Currently supported directives are:

- `SkipDirective`
- `IncludeDirective`

### Fragment

The protocol `GQLFragmentable` can allow objects to easily be encoded into a query or request.

```swift
struct Object {
    let name: String
    let age: Int
}

extension Object: GQLFragmentable {
    // required
    static var graqhQl: GraphQLExpression {
        "name"
        "age"
    }
    // optional - will be synthesized from object Type name if not implemented
    static let fragmentName = "myobject"
    static var fragmentType = "MyObject"
}
```

```graphql
...myobject
fragment myobject on MyObject { name age }
```

> **_Tip_**: If your object has a custom `CodingKeys` implementation, conform your type to `GQLCodable` and its CodingKeys to `CaseIterable`

```swift
struct Object: GQLFragmentable, GQLCodable {
    let name: String
    let age: Int

    enum CodingKeys: String, CodingKey, CaseIterable {
        case name
        case age
    }
}
```

```graphql
...object
fragment object on Object { name age }
```

Once your object conforms to `GQLFragmentable`, it can be used in a `GQLFragment` object in your query

```swift
let node = GQLNode("test") {
    GQLFragment(Object.self)
    Object.asFragment()
}
```

```graphql
test { ...myobject }
fragment myobject on MyObject { name age }
```

## Query

The `GQL` function builder object is used for creating the query for graphql (as seen above).

Example:

```swift
let query = GQL {
    GQLNode("allNodes") {
        GQLNode("frag") {
            Frag2.asFragment()
        }
        "hi"
        "ok"
    }
}

let json = try query.encode()
```

```graphql
query {
    allNodes {
        frag {
            ...frag2
        }
        hi
        ok
    }
}

fragment frag2 on Frag2 {
    ...
}
*/
```

```json
{
  "query": "{ query allNodes { frag { ...frag2 } hi ok } } fragment frag2 on Frag2 { ... }"
}
```

## Mutation

`GQLMutation` is similar to the `GQLQuery`. Generally you would include the operationName for a mutation.

```swift
let mutation = GQL(.mutation, name: "NewPerson") {
    GQLNode("newPerson") {
        GQLNode("person", alias: "createdPerson") {
            GQLFragment(Frag2.self)
        }
    }
    .withArgument("id", value: "123")
    .withArgument("name", value: "taylor")
    .withArgument("age", value: 666)
}

let json = try query.encode()
```

```graphql
mutation NewPerson {
    newPerson(id: "123", name: "taylor", age: 666) {
        createdPerson: person {
            ...frag2
        }
    }
}

fragment frag2 on Frag2 {
    ...
}
```

```json
{
  "query": "mutation { newPerson(id: \"123\", name: \"taylor\", age: 666) { createdPerson: person { ...frag2 } } fragment frag2 on Frag2 { ... }"
}
```

#### Variables

Add variables to `GQL`. This will include the parameter in the head of the query as well as embed its contents into a dictionary to be serialized when you turn the query into json.

```swift
let query = GQL(name: "GetIt") {
    GQLNode("node") {
        "hello"
    }
    .withArgument("rating", variableName: "r")
}
.withVariable("rating", value: 5)

let json = try query.encode()
```

```graphql
mutation GetIt($rating: Int) {
    node(rating: $r) {
        "hello"
    }
}
```

```json
{
  "query": "mutation GetIt($rating: Int) { node(rating: $r) { hello } }",
  "variables": {
    "rating": 5
  }
}
```

## Request

A simple request struct is included to help create `URLRequest` to be sent over the network. The reason it is generic over `T, U` is that the `GraphQLRequest` has a function for decoding graphql responses along with graphql errors.

Requests can be customized with respect to the headers (`[HTTPHeader]`), encoder (`JSONEncoder`), and decoder (`JSONDecoder`) at 3 levels.

- `SwiftyGraphQL` singleton, (which is where you configure the endpoint), which will apply to every request (unless overridden)
- On the `GraphQLRequest.init(_:_:_:_:)` which will apple to all requests of that type (unless overridden)
- On the urlRequest encoding or json decoding functions

```swift
public struct GraphQLRequest<T: Decodable> {
    public let query: GQL
    public var headers: HTTPHeaders
    public var encoder: JSONEncoder?
    public var encodePlugins: [(inout URLRequest) -> Void]
    public var decoder: JSONDecoder?

    public func urlRequest() throws -> URLRequest { ... }
    public func decode(data: Data) throws -> GQLResponse<T> { ... }
}
```

This gives flexibility to adapt headers or use a custom decoders without effecting other requests/config

## Response

Helpers for response decoding have been included. This removes the requirement to make all return structs include the `data` key at a level up in the object.

```swift
extension JSONDecoder {
    public func graphQLDecode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        do {
            return try decode(type, from: data)
        } catch {
            let graphQLError = try? JSONDecoder().decode(GQLErrors.self, from: data)
            throw graphQLError ?? error
        }
    }
}

extension GraphQLRequest {
    public func decode(data: Data) throws -> GQLResponse<T> {
        let decoder = self.decoder ?? SwiftyGraphQL.shared.responseDecoder
        return try decoder.graphQLDecode(GQLResponse<T>.self, from: data)
    }
}
```

Could decode a response that looks like:

```json
{
    "data": {
        {
            "name": "taylor",
            "age": 666
        }
    }
}
```

Additionaly, if decoding cannot be completed, the decoder will try to decode a `GQLErrors` which graphql will return if there is an error in your query/mutation/schema. `GQLErrors` conforms to `Error` and is made up of an array of `GQLError`.

## Examples

From the graphql website:

[Fields](https://graphql.org/learn/queries/#fields)

```swift
GQL {
    GQLNode("hero") {
        "name"
    }
}
```

```graphql
query {
  hero {
    name
  }
}
```

```swift
GQL {
    GQLNode("hero") {
        "name"
        GQLNode("friends") {
            "name"
        }
    }
}
```

```graphql
query {
  hero {
    name
    friends {
      name
    }
  }
}
```

[Arguments](https://graphql.org/learn/queries/#arguments)

```swift
GQL {
    GQLNode("human") {
        "name"
        GQLEmpty("height")
            .withArgument("unit", value: "FOOT")
    }
    .withArgument("id", value: "1000")
}
```

```graphql
query {
  human(id: "1000") {
    name
    height(unit: "FOOT")
  }
}
```

Aliases](https://graphql.org/learn/queries/#aliases)

```swift
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
```

```graphql
query {
  empireHero: hero(episode: "EMPIRE") {
    name
  }
  jediHero: hero(episode: "JEDI") {
    name
  }
}
```

[Fragments](https://graphql.org/learn/queries/#fragments)

```swift
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
```

```graphql
query {
  leftComparison: hero(episode: "EMPIRE") {
    ...comparisonFields
  }
  rightComparison: hero(episode: "JEDI") {
    ...comparisonFields
  }
}

fragment comparisonFields on Character {
  name
  appearsIn
  friends {
    name
  }
}
```

```swift
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
```

```graphql
query HeroComparison($first: Int) {
  leftComparison: hero(episode: "EMPIRE") {
    ...comparisonFields
  }
  rightComparison: hero(episode: "JEDI") {
    ...comparisonFields
  }
}

fragment comparisonFields on Character {
  name
  friendsConnection(first: $first) {
    totalCount
    edges {
      node {
        name
      }
    }
  }
}
```

[Operation Names](https://graphql.org/learn/queries/#operation-name)

```swift
GQL(name: "HeroNameAndFriends") {
    GQLNode("hero") {
        "name"
        GQLNode("friends") {
            "name"
        }
    }
}
```

```graphql
query HeroNameAndFriends {
  hero {
    name
    friends {
      name
    }
  }
}
```

[Variables](https://graphql.org/learn/queries/#variables)

```swift
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
.withVariable("episode", value: Episode.jedi as Episode?) // withouth `as Episode` it would output as `Episode!`
```

```graphql
query HeroNameAndFriends($episode: Episode) {
  hero(episode: $episode) {
    name
    friends {
      name
    }
  }
}

variables:
{
  "episode": "JEDI"
}
```

[Default Variables](https://graphql.org/learn/queries/#default-variables)

```swift
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
```

```graphql
query HeroNameAndFriends($episode: Episode!) {
  hero(episode: $episode) {
    name
    friends {
      name
    }
  }
}

variables:
{
  "episode": "JEDI"
}
```

[Directives](https://graphql.org/learn/queries/#directives)

```swift
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
```

```graphql
query Hero($episode: Episode, $withFriends: Boolean) {
  hero(episode: $episode) {
    name
    friends @include(if: $withFriends) {
      name
    }
  }
}

variables:
{
  "episode": "JEDI",
  "withFriends": false
}
*/
```

[Mutations](https://graphql.org/learn/queries/#mutations)

```swift
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
```

```graphql
mutation CreateReviewForEpisode($ep: Episode!, $review: ReviewInput!) {
  createReview(episode: $ep, review: $review) {
    stars
    commentary
  }
}

variables:
{
  "ep": "JEDI",
  "review": {
    "stars": 5,
    "commentary": "This is a great movie!"
  }
}
```

[Inline Fragments](https://graphql.org/learn/queries/#inline-fragments)
TODO: implement

Advanced example

```swift
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
```

```graphql
query MyCoolQuery($cool: Boolean!, $review: String, $type1: T1!, $type2: T2!) {
    realFirst: first(t1: $type1) {
        hello
        there
        ...myfragment
        inner(age: 666, fraction: 2.59, name: \"taylor\", rev: $review) {
            ...adhoc
            cool @skip(if: $cool)
            supernested(t2: $type2) {
                ...myfragment
            }
        }
    }
}

fragment adhoc on MyFragment { p1 p2 } fragment myfragment on MyFragment { p1 p2 hithere }
```

```json
{
  "query": "query MyCoolQuery($cool: Boolean!, $review: String, $type1: T1!, $type2: T2!) { realFirst: first(t1: $type1) { hello there ...myfragment inner(age: 666, fraction: 2.59, name: \"taylor\", rev: $review) { ...adhoc cool @skip(if: $cool) supernested(t2: $type2) { ...myfragment } } } } fragment adhoc on MyFragment { p1 p2 } fragment myfragment on MyFragment { p1 p2 hithere }",
  "variables": {
    "type2": {
      "nested": { "name": "taylor", "active": true },
      "temperature": 2.5,
      "weather": "pretty great"
    },
    "type1": { "float": 1.5, "int": 1, "string": "cool name" },
    "review": "this is great",
    "cool": true
  }
}
```
