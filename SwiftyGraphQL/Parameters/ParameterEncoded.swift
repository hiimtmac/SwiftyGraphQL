//
//  ParameterEncoded.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-24.
//  Copyright © 2018 hiimtmac. All rights reserved.
//

import Foundation

private let slash = "\\"
private let quote = "\""
private let slashSlash = """
\\\\
"""
private let slashQuote = """
\\\"
"""

public protocol ParameterEncoded {
    func graphEncoded() -> String
}

extension String: ParameterEncoded {
    public func graphEncoded() -> String {
        let slashEncoded = self.replacingOccurrences(of: slash, with: slashSlash)
        let quoteEncoded = slashEncoded.replacingOccurrences(of: quote, with: slashQuote)
        return """
        "\(quoteEncoded)"
        """
    }
}

extension Int: ParameterEncoded {
    public func graphEncoded() -> String {
        return "\(self)"
    }
}

extension Double: ParameterEncoded {
    public func graphEncoded() -> String {
        return "\(self)"
    }
}

extension Bool: ParameterEncoded {
    public func graphEncoded() -> String {
        return "\(self)"
    }
}

extension Optional: ParameterEncoded where Wrapped == ParameterEncoded {
    public func graphEncoded() -> String {
        guard let self = self else { return "null" }
        return self.graphEncoded()
    }
}
