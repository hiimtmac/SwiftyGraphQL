//
//  ParameterRepresentable.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-04-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public protocol GraphQLArgument {
    var parameterValue: String { get }
}

extension String: GraphQLArgument {
    public var parameterValue: String {
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
    public var parameterValue: String {
        return "\(self)"
    }
}

extension Double: GraphQLArgument {
    public var parameterValue: String {
        return "\(self)"
    }
}

extension Float: GraphQLArgument {
    public var parameterValue: String {
        return "\(self)"
    }
}

extension Bool: GraphQLArgument {
    public var parameterValue: String {
        return "\(self)"
    }
}

extension Array: GraphQLArgument where Element: GraphQLArgument {
    public var parameterValue: String {
        let parametersEncoded = self
            .map { $0.parameterValue }
            .sorted()
            .joined(separator: ", ")
        
        return "[ \(parametersEncoded) ]"
    }
}

extension Dictionary: GraphQLArgument where Key == String, Value: GraphQLArgument {
    public var parameterValue: String {
        let parametersEncoded = self
            .map { #""\#($0.key)": \#($0.value.parameterValue)"# }
            .sorted()
            .joined(separator: ", ")
        
        return "{ \(parametersEncoded) }"
    }
}

extension Optional: GraphQLArgument where Wrapped == GraphQLArgument {
    public var parameterValue: String {
        guard let self = self else { return "null" }
        return self.parameterValue
    }
}
