//
//  Variable.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-04-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public protocol GraphQLVariableRepresentable: Encodable {
//    associatedtype Sub: Encodable
    static var variableType: String { get }
}

extension GraphQLVariableRepresentable {
//    public typealias Sub = Self
    public var parameterValue: String {
        return "$"
    }
}

extension GraphQLObject where Self: GraphQLVariableRepresentable {
    public static var variableType: String {
        return entityName
    }
}

extension String: GraphQLVariableRepresentable {
    public static var variableType: String {
        return "String"
    }
}

extension Int: GraphQLVariableRepresentable {
    public static var variableType: String {
        return "Integer"
    }
}

extension Double: GraphQLVariableRepresentable {
    public static var variableType: String {
        return "Float"
    }
}

extension Float: GraphQLVariableRepresentable {
    public static var variableType: String {
        return "Float"
    }
}

extension Bool: GraphQLVariableRepresentable {
    public static var variableType: String {
        return "Boolean"
    }
}


//extension Array: GraphQLVariableRepresentable where Element: GraphQLVariableRepresentable {
//    public func graphQLEncoded() -> String {
//        let parametersEncoded = self
//            .map { $0.graphQLEncoded() }
//            .sorted()
//            .joined(separator: ", ")
//        
//        return "[ \(parametersEncoded) ]"
//    }
//}
//
//extension Dictionary: GraphQLArgument where Key == String, Value: GraphQLArgument {
//    public func graphQLEncoded() -> String {
//        let parametersEncoded = self
//            .map { #""\#($0.key)": \#($0.value.graphQLEncoded())"# }
//            .sorted()
//            .joined(separator: ", ")
//        
//        return "{ \(parametersEncoded) }"
//    }
//}
//
