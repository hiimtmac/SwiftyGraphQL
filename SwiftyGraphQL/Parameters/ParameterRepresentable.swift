//
//  ParameterRepresentable.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-04-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public protocol GraphQLParameterRepresentable {
    var parameterValue: String { get }
}

extension String: GraphQLParameterRepresentable {
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

extension Int: GraphQLParameterRepresentable {
    public var parameterValue: String {
        return "\(self)"
    }
}

extension Double: GraphQLParameterRepresentable {
    public var parameterValue: String {
        return "\(self)"
    }
}

extension Float: GraphQLParameterRepresentable {
    public var parameterValue: String {
        return "\(self)"
    }
}

extension Bool: GraphQLParameterRepresentable {
    public var parameterValue: String {
        return "\(self)"
    }
}

extension Array: GraphQLParameterRepresentable where Element: GraphQLParameterRepresentable {
    public var parameterValue: String {
        let parametersEncoded = self
            .map { $0.parameterValue }
            .sorted()
            .joined(separator: ", ")
        
        return "[ \(parametersEncoded) ]"
    }
}

extension Dictionary: GraphQLParameterRepresentable where Key == String, Value: GraphQLParameterRepresentable {
    public var parameterValue: String {
        let parametersEncoded = self
            .map { #""\#($0.key)": \#($0.value.parameterValue)"# }
            .sorted()
            .joined(separator: ", ")
        
        return "{ \(parametersEncoded) }"
    }
}

extension Optional: GraphQLParameterRepresentable where Wrapped == GraphQLParameterRepresentable {
    public var parameterValue: String {
        guard let self = self else { return "null" }
        return self.parameterValue
    }
}
