# SwiftyGraphQL

[![Platform](https://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](https://developer.apple.com/swift)
[![Swift Version](https://img.shields.io/badge/swift4-compatible-4BC51D.svg?style=flat)](https://developer.apple.com/swift)

This small library helps to make typesafe(er) graphql queries & mutations

## Requirements

- Swift 4.2+

## Usage

The main object of this framework is the `Node` enumeration. It is used to create nodes and the contents within each node. It will create the raw query object string as well as synthesize any fragment types (conforming to `GraphQLFragmentRepresentable`) and create a fragment string.

### Node

```swift
public enum Node {
    indirect case node(String?, String, [String: String]?, [Node])
    case attributes([String])
    case fragment(GraphQLFragmentRepresentable.Type)
    ...
}

// Node.node(`Alias`, `GraphQLEntity`, `Parameters`, `Child Nodes`)
// Node.node(String?, String, [String: String]?, [Node])
```

Example usage:

```swift
let node = Node.node("root", "Root", nil, [
    .node(nil, "sub", nil, [.attributes(["thing1", "thing2"])]),
    .attributes(["thing3", "thing4"]),
    .fragment(Object.self)
])

/*
{
    root: Root {
        sub: sub {
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
{ root: Root { sub: sub { thing1 thing2 } thing3 thing4 ...object } } fragment object on Object { ... // object attributes }
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

### Query

The `GraphQLQuery` object is initialized with a `Node` object and takes care of creating the query for graphql.

Example:
```swift
let node = Node.node(nil, "allNodes", nil, [.node(nil, "frag", nil, [.fragment(Frag2.self)]), .attributes(["hi", "ok"])])
let query = GraphQLQuery(returning: node)
let json = try JSONEncoder().encode(query)

/*
Raw Query:
allNodes: allNodes {
    frag: frag {
        ...frag2
    }
    hi
    ok
}

Fragment:
fragment frag2 on Frag2 {
    ...
}
*/
```

```json
{
    "query": "{ allNodes: allNodes { frag: frag { ...frag2 } hi ok } } fragment frag2 on Frag2 { ... }"
}
```

#### Alias

If an alias is specified on a `Node.node(...)` object, it will be used, otherwise it will default to the GraphQLEntity name.

```swift

let noAlias = Node.node(nil, "object", nil, [.attributes(["hi"])])
/*
object: object {
    hi
}
*/

let alias = Node.node("myObject", "object", nil, [.attributes(["hi"])])
/*
myObject: object {
    hi
}
*/
```

#### GraphQLEntity

This is the name of the graphql entity, setup in the graphql schema.

#### Parameters

If parameters for a node are specified, they will be encoded into the query.

>Note: quotes **must** be escaped

```swift
let node = Node.node("myNode", "allNodes", ["since": "8", "id": ""\"123\""], [.node(nil, "frag", nil, [.fragment(Frag2.self)]), .attributes(["hi", "ok"])])
let query = GraphQLQuery(returning: node)

/*
Raw Query:
myNode: allNodes(since: 8, name: "123") {
    frag: frag {
        ...frag2
    }
    hi
    ok
}

Fragment:
fragment frag2 on Frag2 {
    ...
}
*/
```

### Mutation

The `GraphQLQuery` object is initialized with a `Node` object and takes care of creating the query for graphql.

>Note: Quotes **must** be escaped.

```swift
let mutation = "newPerson(id: \"123\", name: \"taylor\", age: 666)"
let node = Node.node("createdPerson", "person", nil, [.fragment(Frag2.self)])
let query = GraphQLMutation(mutation: mutation, returning: node)
let json = try JSONEncoder().encode(query)

/*
Raw Query:
newPerson(id: "123", name: "taylor", age: 666) {
    createdPerson: person {
        ...frag2
    }
}

Fragment:
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

### Response

Helper objects included for decoding graphql requests: `GraphQLResponse` & `GraphQLResponseCustomErrorType`. `GraphQLResponse` assumes an optional error type of `[String]` while `GraphQLResponseCustomErrorType` lets you specify the error format.

For example:

```swift
let response = try! JSONDecoder().decode(GraphQLResponse<[String]>.self, from: data)
```

Could decode a response that looks like:

```json
{
    "data": [
        "hi",
        "hello"
    ]
}
```

or

```json
{
    "data": [
        "hi",
        "hello"
    ],
    "errors": [
        "something bad",
        "another bad thing"
    ]
}
```

Likewise if a special error type needed to be specified:

```swift

struct ErrorType: Decodable {
    let code: Int
    let name: String
}

struct ObjectType: Decodable {
    let name: String
    let age: Int
}

let response = try! JSONDecoder().decode(GraphQLResponseCustomErrorType<[ObjectType], [ErrorType]>.self, from: data)
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

or

```json
{
    "data": [
        {
            "name": "taylor",
            "age": 666
        }
    ],
    "errors": [
        {
            "code": 666,
            "name": "fatal error occurred"
        }
    ]
}
```
