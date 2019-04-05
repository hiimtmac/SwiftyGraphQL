//
//  ParameterEncoded.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-24.
//  Copyright © 2018 hiimtmac. All rights reserved.
//

import Foundation

public protocol GraphQLArgument {
    func graphQLEncoded() -> String
}

extension String: GraphQLArgument {
    public func graphQLEncoded() -> String {
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

extension Int: GraphQLArgument {
    public func graphQLEncoded() -> String {
        return "\(self)"
    }
}

extension Double: GraphQLArgument {
    public func graphQLEncoded() -> String {
        return "\(self)"
    }
}

extension Float: GraphQLArgument {
    public func graphQLEncoded() -> String {
        return "\(self)"
    }
}

extension Bool: GraphQLArgument {
    public func graphQLEncoded() -> String {
        return "\(self)"
    }
}

extension Array: GraphQLArgument where Element: GraphQLArgument {
    public func graphQLEncoded() -> String {
        let parametersEncoded = self
            .map { $0.graphQLEncoded() }
            .sorted()
            .joined(separator: ", ")
        
        return "[ \(parametersEncoded) ]"
    }
}

extension Dictionary: GraphQLArgument where Key == String, Value: GraphQLArgument {
    public func graphQLEncoded() -> String {
        let parametersEncoded = self
            .map { #""\#($0.key)": \#($0.value.graphQLEncoded())"# }
            .sorted()
            .joined(separator: ", ")
        
        return "{ \(parametersEncoded) }"
    }
}

extension Optional: GraphQLArgument where Wrapped == GraphQLArgument {
    public func graphQLEncoded() -> String {
        guard let self = self else { return "null" }
        return self.graphQLEncoded()
    }
}
