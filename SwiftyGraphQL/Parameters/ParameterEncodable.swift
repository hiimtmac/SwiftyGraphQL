//
//  ParameterEncoded.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-24.
//  Copyright © 2018 hiimtmac. All rights reserved.
//

import Foundation

private let slash = #"\"#
private let quote = "\""
private let slashSlash = #"\\"#
private let slashQuote = #"\""#

public protocol GraphQLParameterEncodable {
    func graphEncoded() -> String
}

extension String: GraphQLParameterEncodable {
    public func graphEncoded() -> String {
        let slashEncoded = self.replacingOccurrences(of: slash, with: slashSlash)
        let quoteEncoded = slashEncoded.replacingOccurrences(of: quote, with: slashQuote)
        return #""\#(quoteEncoded)""#
    }
}

extension Int: GraphQLParameterEncodable {
    public func graphEncoded() -> String {
        return "\(self)"
    }
}

extension Double: GraphQLParameterEncodable {
    public func graphEncoded() -> String {
        return "\(self)"
    }
}

extension Bool: GraphQLParameterEncodable {
    public func graphEncoded() -> String {
        return "\(self)"
    }
}

extension GraphQLParameters: GraphQLParameterEncodable {
    public func graphEncoded() -> String {
        let parametersEncoded = parameters
            .map { "\($0.key): \($0.value.graphEncoded())" }
            .sorted()
            .joined(separator: ", ")
        
        return "{ \(parametersEncoded) }"
    }
}

extension Array: GraphQLParameterEncodable where Element: GraphQLParameterEncodable {
    public func graphEncoded() -> String {
        let parametersEncoded = self
            .map { $0.graphEncoded() }
            .sorted()
            .joined(separator: ", ")
        
        return "[ \(parametersEncoded) ]"
    }
}

extension Optional: GraphQLParameterEncodable where Wrapped == GraphQLParameterEncodable {
    public func graphEncoded() -> String {
        guard let self = self else { return "null" }
        return self.graphEncoded()
    }
}
