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
    indirect case node(String?, String, Parameters?, [Node])
    case attributes([String])
    case fragment(GraphQLFragmentRepresentable.Type)
    ...
}

// Node.node(`Alias`, `GraphQLEntity`, `Parameters`, `Child Nodes`)
// Node.node(String?, String, Parameters?, [Node])
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

The `Parameters` object handles options passed to the query/mutation in the format of a `[String: ParameterEncoded]` dictionary. 
Anything conforming to `ParameterEncoded` can be put into the parameters object, thought currently only `String`, `Int`, & `Double` conform. 
Additionally, escaping `\` & `"` sucks, so the `String` implementation of `ParameterEncoded` handles make it graphql safe.
Any optional values are encoded as `NULL` (which I think is better than omitting the whole key/value pair).

```swift
let num: Int? = nil
let string: String? = nil
let parameters = Parameters(["since": num, "name": string ?? "defaultValue", "other": 2, "date": "today", "zzz": nil])
let node = Node.node("myNode", "allNodes", parameters, [.node(nil, "frag", nil, [.fragment(Frag2.self)]), .attributes(["hi", "ok"])])
let query = GraphQLQuery(returning: node)

/*
Raw Query:
myNode: allNodes(date: "today", name: "defaultValue", other: 2, since: NULL, zzz: NULL) {
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

### Mutations

A `Mutation` object has been included to help create the mutation string along with the returning query.

```swift
let parameters = Parameters(["id": "123", "name": "taylor", "age": 666])
let mutation = Mutation(title: "newPerson, parameters: parameters)
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

### GraphQLError

If you have a type that conforms to `GraphQLDecodable` (which only needs to conform to `Decodable`), you can use an extension 
on `JSONDecoder` to `graphQLDecode<T>(...)`. If the decoding of your type fails because the `data` node is missing from the 
JSON because a graphQL error has been thrown, this method will attemp to decode the graphql error type and throw that instead
of the normal JSONDecoder error.
