# SwiftyGraphQL

[![Platform](https://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](https://developer.apple.com/swift)
[![Swift Version](https://img.shields.io/badge/swift4-compatible-4BC51D.svg?style=flat)](https://developer.apple.com/swift)

This small library helps to make typesafe(er) graphql queries & mutations

## Requirements

- Swift 5.1+

## Examples

From the graphql website:

```swift
// https://graphql.org/learn/queries/#fields
let node = GraphQLNode.node(name: "hero", [
    .attributes(["name"])
])
let query = GraphQLQuery(query: node)
/*
{
  hero {
    name
  }
}
*/

let node = GraphQLNode.node(name: "hero", [
    .node(name: "friends", [
        .attributes(["name"])
    ]),
    .attributes(["name"])
])
let query = GraphQLQuery(query: node)
/*
{
  hero {
    name
    # Queries can have comments!
    friends {
      name
    }
  }
}
*/

// https://graphql.org/learn/queries/#arguments
let node = GraphQLNode.node(name: "human", arguments: ["id":"1000"], [
    .attributes(["name","height"])
])
let query = GraphQLQuery(query: node)
/*
{
  human(id: "1000") {
    name
    height
  }
}
*/

TODO: Support this
{
  human(id: "1000") {
    name
    height(unit: FOOT)
  }
}

// https://graphql.org/learn/queries/#aliases
let node1 = GraphQLNode.node(alias: "empireHero", name: "hero", arguments: ["episode": "EMPIRE"], [
    .attributes(["name"])
])
let node2 = GraphQLNode.node(alias: "jediHero", name: "hero", arguments: ["episode": "JEDI"], [
    .attributes(["name"])
])
let query = GraphQLQuery(query: [node1, node2])
/*
{
  empireHero: hero(episode: EMPIRE) {
    name
  }
  jediHero: hero(episode: JEDI) {
    name
  }
}
*/

// https://graphql.org/learn/queries/#fragments
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

let node1 = GraphQLNode.node(alias: "leftComparison", name: "hero", arguments: ["episode": "EMPIRE"], [
    .fragment(Character.self)
])
let node2 = GraphQLNode.node(alias: "rightComparison", name: "hero", arguments: ["episode": "JEDI"], [
    .fragment(Character.self)
])
let query = GraphQLQuery(query: [node1, node2])
/*
{
  leftComparison: hero(episode: EMPIRE) {
    ...comparisonFields
  }
  rightComparison: hero(episode: JEDI) {
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

let arg = GraphQLVariable(name: "first", value: 3)
struct Character: GraphQLFragment {
    static var entityName: String { "Character" }
    static var fragmentName: String { "comparisonFields" }
    static var fragmentContent: GraphQLRepresentable {
        let attributes = GraphQLNode.attributes(["name"])
        let friends = GraphQLNode.node(name: "friendsConnection", arguments: ["first": arg], [
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

let node1 = GraphQLNode.node(alias: "leftComparison", name: "hero", arguments: ["episode": "EMPIRE"], [
    .fragment(Character.self)
])
let node2 = GraphQLNode.node(alias: "rightComparison", name: "hero", arguments: ["episode": "JEDI"], [
    .fragment(Character.self)
])
let query = GraphQLQuery(query: [node1, node2], variables: [arg], operationName: "HeroComparison").query, compare)
/*
// NOTE: we dont need default like in real example (HeroComparison($first: Int = 3)
//       because swift ensure we will have a value there
//       there is a variable init that can take an optional with a default
query HeroComparison($first: Int) {  
  leftComparison: hero(episode: EMPIRE) {
    ...comparisonFields
  }
  rightComparison: hero(episode: JEDI) {
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
func testOperationName() {
let node = GraphQLNode.node(name: "hero", [
    .attributes(["name"]),
    .node(name: "friends", [
        .attributes(["name"])
    ])
])
let query = GraphQLQuery(query: node, operationName: "HeroNameAndFriends")
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
let arg = GraphQLVariable(name: "episode", value: "JEDI")

let node = GraphQLNode.node(name: "hero", arguments: ["episode": arg], [
    .attributes(["name"]),
    .node(name: "friends", [
        .attributes(["name"])
    ])
])
let query = GraphQLQuery(query: node, variables: [arg], operationName: "HeroNameAndFriends")
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
let arg = GraphQLVariable(name: "episode", value: nil, default: "JEDI")

let node = GraphQLNode.node(name: "hero", arguments: ["episode": arg], [
    .attributes(["name"]),
    .node(name: "friends", [
        .attributes(["name"])
    ])
])

let query = GraphQLQuery(query: node, variables: [arg], operationName: "HeroNameAndFriends")
/*
query HeroNameAndFriends($episode: Episode = JEDI) {
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
TODO: Implement this

// https://graphql.org/learn/queries/#mutations
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
```

## Usage

The main object of this framework is the `GraphQLNode` enumeration. It is used to create nodes and the contents within each node. It will create the raw query object string as well as synthesize any fragment types (conforming to `GraphQLFragmentRepresentable`) and create a fragment string.

### Node

```swift
public enum GraphQLNode {
    indirect case node(alias: String? = nil, name: String, parameters: GraphQLParameters? = nil, [GraphQLNode])
    case attributes([String])
    case fragment(GraphQLFragmentRepresentable.Type)
    ...
}

// GraphQLNode.node(`Alias`, `GraphQLEntity`, `Parameters`, `Child Nodes`)
// GraphQLNode.node(String?, String, GraphQLParameters?, [GraphQLNode])
```

Example usage:

```swift
let node = GraphQLNode.node("root", "Root", nil, [
    .node(name: "sub", [
        .attributes(["thing1", "thing2"])
    ]),
    .attributes(["thing3", "thing4"]),
    .fragment(Object.self)
])

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

If an alias is specified on a `GraphQLNode.node(...)` object, it will be used, otherwise it will default to the GraphQLEntity name.

```swift
let noAlias = GraphQLNode.node(name: "object", [
    .attributes(["hi"])
])
/*
object {
    hi
}
*/

let alias = GraphQLNode.node(alias: "myObject", name: "object", nil, [
    .attributes(["hi"])
])
/*
myObject: object {
    hi
}
*/
```

### Fragment

The protocol `GraphQLFragmentRepresentable` can allow objects to easily be encoded into a query or request.

```swift
struct Object {
    let name: String
    let age: Int
}

extension Object: GraphQLFragmentRepresentable {
    // required
    static var attributes: [String] { return ["name", "age"] }
    // optional - will be synthesized from object Type name if not implemented
    static var entityName: String { return "MyObject" }
    static var fragmentName: String { return "myobject" }
}

let fragment = Object.fragment
print(fragment)

/*
fragment myobject on MyObject {
    name
    age
}
*/
```

>***Tip***: If your object has a custom `CodingKeys` implementation, conform it to `CaseIterable`

```swift
struct Object {
    let name: String
    let age: Int
}

extension Object: Decodable, GraphQLFragmentRepresentable {
    enum CodingKeys: String, CodingKey {
        case name
        case age
    }

    static var attributes: [String] { return CodingKeys.allCases.map { $0.stringValue } }
}

let fragment = Object.fragment
print(fragment)

/*
fragment object on Object {
    name
    age
}
*/
```

### Parameters

The `GraphQLParameters` object handles options passed to the query/mutation in the format of a `[String: GraphQLParameterEncodable]` dictionary. Anything conforming to `GraphQLParameterEncodable` can be put into the parameters object. Additionally, escaping `\` & `"` sucks, so the `String` implementation of `GraphQLParameterEncodable` handles make it graphql safe. Any optional values are encoded as `NULL` (which I think is better than omitting the whole key/value pair).

#### Conforming Types

Currently, the following types are valid for use in parameters:

* `String`
* `Int`
* `Double`
* `Float`
* `Bool`
* `GraphQLParameters`
* `Array` when its elements are also `GraphQLParameterEncodable`
* `Optional`
* Custom types conforming to `GraphQLParameterEncodable`

#### Example

```swift
let num: Int? = nil
let string: String? = nil
let parameters = GraphQLParameters(["since": num, "name": string ?? "defaultValue", "other": 2, "date": "today", "zzz": nil])
let node = GraphQLNode.node(alias: "myNode", name: "allNodes", parameters: parameters, [
    .node(nil, "frag", nil, [
        .fragment(Frag2.self)
    ]), 
    .attributes(["hi", "ok"])
])
let query = GraphQLQuery(query: node)

/*
query {
    myNode: allNodes(date: "today", name: "defaultValue", other: 2, since: NULL, zzz: NULL) {
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

#### Helpers

- Parameters can be combined through the `+` operator and will overwrite any colliding parameters from the lhs arg with parameters from the rhs arg. 
- Parameters can be mutated with the `add` function, passing a `String` key and `GraphQLEncodableParameter?` value
- Parameters can also be subscripted like a normal dictionary.

### Variables

The `GraphQLVariables` object handles options passed to the query/mutation in the format of a `[String: GraphQLVariable]` dictionary. Anything conforming to `GraphQLVariableRepresentable` can be put into the `GraphQLVariable`.

#### Conforming Types

Currently, the following types are already valid for use in variables:

* `String`
* `Int`
* `Double`
* `Float`
* `Bool`
* Anything conforming to `GraphQLVariableRepresentable`

#### Example

```swift
struct Object: GraphQLVariableRepresentable {
    let name: String
}

let object = Object(name: "hiimtmac")
let variable = GraphQLVariable(name: "object", value: object)

let vairables = GraphQLVariables([variable])
let node = GraphQLNode.node(name: "allNodes", parameters: ["obj": object], [
    .node(name: "frag", [
        .fragment(Frag2.self)
    ]), 
    .attributes(["hi", "ok"])
])
let query = GraphQLQuery(query: node, variables: variables)

/*
query($object: Object) {
    allNodes(obj: $object) {
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

#### Helpers

- Variables can be combined through the `+` operator and will overwrite any colliding parameters from the lhs arg with parameters from the rhs arg. 
- Variables can also be subscripted like a normal dictionary.
- Variables get json-d in the top level of the request, even with the query

## Query

The `GraphQLQuery` object is initialized with a `GraphQLRepresentable` object and takes care of creating the query for graphql (as seen above).

Example:
```swift
let node = GraphQLNode.node(name: "allNodes", [
    .node(name: "frag", [
        .fragment(Frag2.self)
    ]), 
    .attributes(["hi", "ok"])
])
let query = GraphQLQuery(query: node)
let json = try JSONEncoder().encode(query)

/*
query {
    allNodes {
        frag: frag {
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

`GraphQLQuery` also has an initializer for a mutation. Generally you would include the `operationName: String` field for a mutation.

```swift
let parameters = GraphQLParameters(["id": "123", "name": "taylor", "age": 666])
let node = GraphQLNode.node(name: "newPerson", parameters: parameters, [
    .node(alias: "createdPerson", name: "person", [
        .fragment(Frag2.self)
    ])
])
let query = GraphQLQuery(mutation: node, operationName: "NewPerson")
let json = try JSONEncoder().encode(query)

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

## Request

A simple request struct is included to help create `URLRequest` to be sent over the network. The reason it is generic over `T` is that the `GraphQLRequest` has a function for decoding graphql responses along with graphql errors.

Requests can be customized with respect to the headers (`[HTTPHeader]`), encoder (`JSONEncoder`), and decoder (`JSONDecoder`) at 3 levels.

- `SwiftyGraphQL` singleton, (which is where you configure the endpoint), which will apply to every request (unless overridden)
- On the `GraphQLRequest.init(_:_:_:_:)` which will apple to all requests of that type (unless overridden)
- On the urlRequest encoding or json decoding functions

```swift
public struct GraphQLRequest<T: Decodable> {
    public let query: GraphQLQuery
    public var headers: HTTPHeaders
    public var encoder: JSONEncoder?
    public var decoder: JSONDecoder?
    
    public func urlRequest(headers: HTTPHeaders = .init(), encoder: JSONEncoder? = nil) throws -> URLRequest { ... }
    public func decode(data: Data, decoder: JSONDecoder? = nil) throws -> GraphQLResponse<T> { ... }
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
    public func decode(data: Data, decoder: JSONDecoder? = nil) throws -> GraphQLResponse<T> {
        let decoder = decoder ?? self.decoder ?? SwiftyGraphQL.shared.responseDecoder
        return try decoder.graphQLDecode(GraphQLResponse<T>.self, from: data)
    }
}
```

Could decode a response that looks like:

```json
{
    "data": [
        {
            "name": "taylor",
            "age": 666
        }
    ]
}
```

Additionaly, if decoding cannot be completed, the decoder will try to decode a `GraphQLErrors` which graphql will return if there is an error in your query/mutation/schema. `GraphQLErrors` conforms to `Error` and is made up of an array of `GraphQLError`.
