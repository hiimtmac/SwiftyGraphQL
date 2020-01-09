# SwiftyGraphQL

[![Platform](https://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](https://developer.apple.com/swift)
[![Swift Version](https://img.shields.io/badge/swift4-compatible-4BC51D.svg?style=flat)](https://developer.apple.com/swift)

This library helps to make typesafe(er) graphql queries & mutations, for those who are scared of a library that does codegen

## Requirements

- Swift 5.1+

## Installation

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.

```swift
import PackageDescription

let package = Package(
  name: "TestProject",
  dependencies: [
    .package(url: "https://github.com/hiimtmac/SwiftyGraphQL.git", from: "1.0.0")
  ]
)
```

### Cocoapods

```ruby
target 'MyApp' do
  pod 'SwiftyGraphQL', '~> 1.0'
end
```

## Usage

General usage looks as such

```swift
let query = GQLQuery("HeroNameAndFriends") {
    GQLNode("hero") {
        "name"
        "age"
        GQLNode("friends") {
            "name"
            "age"
        }
    }
    .withVariable(named: "episode", variableName: "episode")
}
.withVariable(named: "episode", value: "JEDI")

/*
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
*/
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

/*
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
*/
```

> Note: Output will be separated by spaces rather than carriage returns

```swift
/*
{ root: Root { sub { thing1 thing2 } thing3 thing4 ...object } } fragment object on Object { ... // object attributes }
*/
```

#### Alias

Add a node alias in  `.init(_ name: String, alias: String? = nil)`. An alias will change the returning json key for that node.

```swift
let node = GQLNode("sub") {
    "thing1"
    "thing2"
}

print(node.gqlQueryString) // sub { thing1 thing2 }

let node = GQLNode("sub", alias: "cool") {
    "thing1"
    "thing2"
}

print(node.gqlQueryString) // cool: sub { thing1 thing2 }
```

#### Arguments

Add arguments to a node using ` func withArgument(named: String, value: GQLArgument?) -> Self`. Anything conforming to `GQLArgument` can be used here. Currently, the following types are valid for use in parameters:

* `String`
* `Int`
* `Double`
* `Float`
* `Bool`
* `Array` -> `where Element: GQLArgument`
* `Dictionary` -> `where Key == String, Value: GQLArgument`
* `Optional` -> `where Wrapped == GQLArgument`
* Custom types conforming to `GQLArgument`

#### Variables

Add variables to an argument using `func withVariable(named: String, variableName: String) -> Self`. Right now this just takes a string variable name.

#### Directives

Use directives with `public func withDirective(_ directive: GQLDirective) -> Self`. Currently supported directives are:

* `SkipDirective`
* `IncludeDirective`
* Custom directives conforming to `GQLDirective`

### Fragment

The protocol `GQLFragmentable` can allow objects to easily be encoded into a query or request.

```swift
struct Object {
    let name: String
    let age: Int
}

extension Object: GQLFragmentable {
    // required
    static var gqlContent: GraphQL { 
        GQLAttributes {
            "name"
            "age"
        }
    }
    // optional - will be synthesized from object Type name if not implemented
    static let fragmentName = "myobject"
    static var fragmentType = "MyObject"
}

print(Object.fragmentString) // fragment myobject on MyObject { name age }
```

>***Tip***: If your object has a custom `CodingKeys` implementation, conform your type to `GQLAttributable` and its CodingKeys to `CaseIterable` 

```swift
struct Object: GQLAttributable {
    let name: String
    let age: Int
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case name
        case age
    }
}

extension Object: GQLFragmentable {
    var gqlContent: GraphQL {
        //  TYPE SAFETY! Will use the coding keys's raw values as the parameter
        GQLAttributes(Self.self) { t in 
            t.name
            t.age
        }
        
        // OR
        
        // will use all keys from `CaseIterable`
        GQLAttributes(CodingKeys.self)
    }
}

print(Object.fragmentString) // fragment myobject on MyObject { name age }
```

Once your object conforms to `GQLFragmentable`, it can be used in a `GQLFragment` object in your query

```swift
let node = GQLNode("test") {
    GQLFragment(Object.self)
}

print(node.gqlQueryString) // test { ...myobject }
print(node.gqlFragmentString) // fragment myobject on MyObject { name age }
```

## Query

The `GQLQuery` function builder object is used for creating the query for graphql (as seen above).

Example:
```swift
let query = GQLQuery {
    GQLNode("allNodes") {
        GQLNode("frag") {
            GQLFragment(Frag2.self)
        }
        "hi"
        "ok"
    }
}

let json = try JSONEncoder().encode(query)

/*
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
    "query": "{ allNodes { frag { ...frag2 } hi ok } } fragment frag2 on Frag2 { ... }"
}
```

## Mutation

`GQLMutation` is similar to the `GQLQuery`. Generally you would include the operationName for a mutation.

```swift
let mutation = GQLMutation("NewPerson") {
    GQLNode("newPerson") {
        GQLNode("person", alias: "createdPerson") {
            GQLFragment(Frag2.self)
        }
    }
    .withArgument(named: "id", value: "123")
    .withArgument(named: "name", value: "taylor")
    .withArgument(named: "age", value: 666)
}

let json = try JSONEncoder().encode(mutation)

/*
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
*/
```

```json
{
    "query": "mutation { newPerson(id: \"123\", name: \"taylor\", age: 666) { createdPerson: person { ...frag2 } } fragment frag2 on Frag2 { ... }"
}
```

#### Variables

Add variables to `GQLQuery`  or `GQLMutation` with `func withVariable<T: GQLVariable>(named: String, value: T) -> Self`. This will include the parameter in the head of the query as well as embed its contents into a dictionary to be serialized when you turn the query into json.

```swift
let query = GQLQuery("GetIt") {
    GQLNode("node") {
        "hello"
    }
    .withVairable(named: "rating", variableName: "r")
}
.withVariable(named: "rating", value: 5)

let json = try JSONEncoder().encode(query)

/*
mutation GetIt($rating: Int) {
    node(rating: $r) {
        "hello"
    }
}
*/
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
public struct GraphQLRequest<T: GQLOperation, U: Decodable> {
    public let query: T
    public var headers: HTTPHeaders
    public var encoder: JSONEncoder?
    public var encodePlugins: [(inout URLRequest) -> Void]
    public var decoder: JSONDecoder?
    
    public func urlRequest() throws -> URLRequest { ... }
    public func decode(data: Data) throws -> GraphQLResponse<T> { ... }
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
            let graphQLError = try? JSONDecoder().decode(GraphQLErrors.self, from: data)
            throw graphQLError ?? error
        }
    }
}

extension GraphQLRequest {
    public func decode(data: Data) throws -> GraphQLResponse<T> {
        let decoder = self.decoder ?? SwiftyGraphQL.shared.responseDecoder
        return try decoder.graphQLDecode(GraphQLResponse<T>.self, from: data)
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

Additionaly, if decoding cannot be completed, the decoder will try to decode a `GraphQLErrors` which graphql will return if there is an error in your query/mutation/schema. `GraphQLErrors` conforms to `Error` and is made up of an array of `GraphQLError`.

## Examples

From the graphql website:

```swift
// https://graphql.org/learn/queries/#fields
let query = GQLQuery {
    GQLNode("hero") {
        "name"
    }
}
/*
query {
  hero {
    name
  }
}
*/

let query = GQLQuery {
    GQLNode("hero") {
        "name"
        GQLNode("friends") {
            "name"
        }
    }
}
/*
query {
  hero {
    name
    friends {
      name
    }
  }
}
*/

// https://graphql.org/learn/queries/#arguments
let query = GQLQuery {
    GQLNode("human") {
        "name"
        GQLNode("height")
            .withArgument(named: "unit", value: "FOOT")
    }
    .withArgument(named: "id", value: "1000")
}
/*
query {
  human(id: "1000") {
    name
    height(unit: "FOOT")
  }
}
*/

// https://graphql.org/learn/queries/#aliases
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
/*
query {
  empireHero: hero(episode: "EMPIRE") {
    name
  }
  jediHero: hero(episode: "JEDI") {
    name
  }
}
*/

// https://graphql.org/learn/queries/#fragments
struct Character: GQLFragmentable {
    static let fragmentName = "comparisonFields"
    
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
/*
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
*/

struct Character: GQLFragmentable {
    static let fragmentName = "comparisonFields"

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
.withVariable(named: "first", value: 5 as Int?) // to make it optional

/*
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
*/

// https://graphql.org/learn/queries/#operation-name
let query = GQLQuery("HeroNameAndFriends") {
    GQLNode("hero") {
        "name"
        GQLNode("friends") {
            "name"
        }
    }
}
/*
query HeroNameAndFriends {
  hero {
    name
    friends {
      name
    }
  }
}
*/

// https://graphql.org/learn/queries/#variables
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
/*
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
*/


// https://graphql.org/learn/queries/#default-variables
// this example doesnt make sense, you would just provide a default value with the optional
enum Episode: String, GQLVariable, Codable {
    case jedi = "JEDI"
}

let optionalValue: Episode? = nil

let _ = GQLQuery("HeroNameAndFriends") {
    GQLNode("hero") {
        "name"
    }
}
.withVariable(named: "episode", value: optionalValue ?? .jedi)
/*
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
*/

// https://graphql.org/learn/queries/#directives
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
/*
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

// https://graphql.org/learn/queries/#mutations
struct ReviewInput: GQLVariable {
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
/*
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
*/

// https://graphql.org/learn/queries/#inline-fragments
TODO: implement

// Advanced example
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

/*
query MyCoolQuery($cool: Boolean!, $review: String, $type1: T1!, $type2: T2!) { 
    realFirst: first(t1: $type1) { 
        ...myfragment
        hello
        hithere
        p1
        p2
        inner(age: 666, fraction: 2.59, name: \"taylor\", rev: $review) { 
            cool @skip(if: $cool)
            p1
            p2
            supernested(t2: $type2) { 
                ...myfragment 
            } 
        } 
        there
    } 
} 
    
fragment myfragment on MyFragment { hithere p1 p2 }
*/

/*
{
    "query":"query MyCoolQuery($cool: Boolean!, $review: String, $type1: T1!, $type2: T2!) { realFirst: first(t1: $type1) { ...myfragment hello hithere p1 p2 inner(age: 666, fraction: 2.59, name: \"taylor\", rev: $review) { cool @skip(if: $cool) p1 p2 supernested(t2: $type2) { ...myfragment } } there } } fragment myfragment on MyFragment { hithere p1 p2 }",
    "variables":{"type2":{"nested":{"name":"taylor","active":true},"temperature":2.5,"weather":"pretty great"},"type1":{"float":1.5,"int":1,"string":"cool name"},"review":"this is great","cool":true}
}
*/
```
