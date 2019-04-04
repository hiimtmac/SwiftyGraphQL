//
//  ParameterEncoded.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-24.
//  Copyright © 2018 hiimtmac. All rights reserved.
//

import Foundation

public protocol GraphQLParameterEncodable {
    func asGraphQLParameter() -> String
}

extension String: GraphQLParameterEncodable {
    public func asGraphQLParameter() -> String {
        var escaped = ""
        for c in self.unicodeScalars {
            switch c {
            case #"\"#: // \
                escaped += #"\\"#
            case "\"": // "
                escaped += #"\""#
            case "\n": // \n
                escaped += #"\n"#
            case "\r": // \r
                escaped += #"\r"#
            default:
                if c.value < 0x20 {
                    escaped += String(format: "\\u%04x", c.value)
                } else {
                    escaped.append(String(c))
                }
            }
        }
        escaped += ""
        return #""\#(escaped)""#
    }
}

extension Int: GraphQLParameterEncodable {
    public func asGraphQLParameter() -> String {
        return "\(self)"
    }
}

extension Double: GraphQLParameterEncodable {
    public func asGraphQLParameter() -> String {
        return "\(self)"
    }
}

extension Float: GraphQLParameterEncodable {
    public func asGraphQLParameter() -> String {
        return "\(self)"
    }
}

extension Bool: GraphQLParameterEncodable {
    public func asGraphQLParameter() -> String {
        return "\(self)"
    }
}

extension GraphQLParameters: GraphQLParameterEncodable {
    public func asGraphQLParameter() -> String {
        let parametersEncoded = parameters
            .map { "\($0.key): \($0.value.asGraphQLParameter())" }
            .sorted()
            .joined(separator: ", ")
        
        return "{ \(parametersEncoded) }"
    }
}

extension Array: GraphQLParameterEncodable where Element: GraphQLParameterEncodable {
    public func asGraphQLParameter() -> String {
        let parametersEncoded = self
            .map { $0.asGraphQLParameter() }
            .sorted()
            .joined(separator: ", ")
        
        return "[ \(parametersEncoded) ]"
    }
}

extension Optional: GraphQLParameterEncodable where Wrapped == GraphQLParameterEncodable {
    public func asGraphQLParameter() -> String {
        guard let self = self else { return "null" }
        return self.asGraphQLParameter()
    }
}
