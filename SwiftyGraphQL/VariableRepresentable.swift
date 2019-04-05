//
//  Variable.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-04-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public protocol GraphQLVariableRepresentable: GraphQLObject, GraphQLArgument, Encodable {

}

extension GraphQLVariableRepresentable {
    func graphQLEncoded() -> String {
        return "$\(Self.entityName.lowercased())HAHAH"
    }
}

extension String: GraphQLVariableRepresentable {

}

extension Int: GraphQLVariableRepresentable {
    public static var entityName: String {
        return "Integer"
    }
}

extension Double: GraphQLVariableRepresentable {
    public static var entityName: String {
        return "Float"
    }
}

extension Float: GraphQLVariableRepresentable {
    public static var entityName: String {
        return "Float"
    }
}

extension Bool: GraphQLVariableRepresentable {
    public static var entityName: String {
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
//extension Optional: GraphQLArgument where Wrapped == GraphQLArgument {
//    public func graphQLEncoded() -> String {
//        guard let self = self else { return "null" }
//        return self.graphQLEncoded()
//    }
//}
