//
//  Argument.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2020-01-07.
//  Copyright © 2020 hiimtmac. All rights reserved.
//

import Foundation

public protocol GraphQLArgumentExpression {
    var gqlArgument: GraphQLExpression { get }
}

public struct GQLArgument: GraphQLExpression, Comparable {
    let name: String
    let value: GraphQLArgumentExpression
    
    public init<T>(name: String, value: T) where T: GraphQLArgumentExpression {
        self.name = name
        self.value = value
    }
    
    public init(name: String, value: GQLVariable) {
        self.name = name
        self.value = value
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
    }
    
    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.name < rhs.name
    }
    
    public func serialize(to serializer: inout Serializer) {
        serializer.write(name)
        serializer.write(": ")
        value.gqlArgument.serialize(to: &serializer)
    }
}

public struct GQLStringVariableArgument: GraphQLArgumentExpression, GraphQLExpression {
    let name: String
    
    public init(_ name: String) {
        self.name = name
    }
    
    public func serialize(to serializer: inout Serializer) {
        serializer.write("$")
        serializer.write(name)
    }
    
    public var gqlArgument: GraphQLExpression { self }
}

extension String: GraphQLArgumentExpression {
    struct GQLArgument: GraphQLExpression {
        let value: String
        
        func serialize(to serializer: inout Serializer) {
            serializer.write("\"")
            serializer.write(value)
            serializer.write("\"")
        }
    }
    
    public var gqlArgument: GraphQLExpression { GQLArgument(value: self) }
}

extension Int: GraphQLArgumentExpression {
    struct GQLArgument: GraphQLExpression {
        let value: Int
        
        func serialize(to serializer: inout Serializer) {
            serializer.write("\(value)")
        }
    }
    
    public var gqlArgument: GraphQLExpression { GQLArgument(value: self) }
}

extension Double: GraphQLArgumentExpression {
    struct GQLArgument: GraphQLExpression {
        let value: Double
        
        func serialize(to serializer: inout Serializer) {
            serializer.write("\(value)")
        }
    }
    
    public var gqlArgument: GraphQLExpression { GQLArgument(value: self) }
}

extension Float: GraphQLArgumentExpression {
    struct GQLArgument: GraphQLExpression {
        let value: Float
        
        func serialize(to serializer: inout Serializer) {
            serializer.write("\(value)")
        }
    }
    
    public var gqlArgument: GraphQLExpression { GQLArgument(value: self) }
}

extension Bool: GraphQLArgumentExpression {
    struct GQLArgument: GraphQLExpression {
        let value: Bool
        
        func serialize(to serializer: inout Serializer) {
            serializer.write("\(value)")
        }
    }
    
    public var gqlArgument: GraphQLExpression { GQLArgument(value: self) }
}

extension Array: GraphQLArgumentExpression where Element: GraphQLArgumentExpression {
    struct GQLArgument<Element>: GraphQLExpression where Element: GraphQLArgumentExpression {
        let value: [Element]
        
        func serialize(to serializer: inout Serializer) {
            serializer.write("[")
            GQLList(value.map(\.gqlArgument), delimiter: ", ").serialize(to: &serializer)
            serializer.write("]")
        }
    }

    public var gqlArgument: GraphQLExpression { GQLArgument(value: self) }
}

// TODO: Object encodable

extension Optional: GraphQLArgumentExpression where Wrapped: GraphQLArgumentExpression {
    struct GQLArgument<Wrapped>: GraphQLExpression where Wrapped: GraphQLArgumentExpression {
        let value: Wrapped?

        func serialize(to serializer: inout Serializer) {
            if let value = value {
                value.gqlArgument.serialize(to: &serializer)
            } else {
                serializer.write("null")
            }
        }
    }

    public var gqlArgument: GraphQLExpression { GQLArgument(value: self) }
}
