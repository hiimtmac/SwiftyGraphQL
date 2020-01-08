//
//  Argument.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2020-01-07.
//  Copyright © 2020 hiimtmac. All rights reserved.
//

import Foundation

public protocol GQLArgument {
    var gqlArgumentValue: String { get }
}

extension String: GQLArgument {
    public var gqlArgumentValue: String {
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

extension Int: GQLArgument {
    public var gqlArgumentValue: String {
        return "\(self)"
    }
}

extension Double: GQLArgument {
    public var gqlArgumentValue: String {
        return "\(self)"
    }
}

extension Float: GQLArgument {
    public var gqlArgumentValue: String {
        return "\(self)"
    }
}

extension Bool: GQLArgument {
    public var gqlArgumentValue: String {
        return "\(self)"
    }
}

extension Array: GQLArgument where Element: GQLArgument {
    public var gqlArgumentValue: String {
        let parametersEncoded = self
            .map { $0.gqlArgumentValue }
            .sorted()
            .joined(separator: ", ")
        
        return "[ \(parametersEncoded) ]"
    }
}

extension Dictionary: GQLArgument where Key == String, Value: GQLArgument {
    public var gqlArgumentValue: String {
        let parametersEncoded = self
            .map { #""\#($0.key)": \#($0.value.gqlArgumentValue)"# }
            .sorted()
            .joined(separator: ", ")
        
        return "{ \(parametersEncoded) }"
    }
}

extension Optional: GQLArgument where Wrapped == GQLArgument {
    public var gqlArgumentValue: String {
        guard let self = self else { return "null" }
        return self.gqlArgumentValue
    }
}
