//
//  Parameters.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-24.
//  Copyright © 2018 hiimtmac. All rights reserved.
//

import Foundation

public struct Parameters: CustomStringConvertible {
    let parameters: [String: ParameterEncoded?]
    
    public init(_ parameters: [String: ParameterEncoded?]) {
        self.parameters = parameters
    }
    
    var encoded: GraphQLStatement {
        guard !parameters.isEmpty else { return "" }
        let parametersEncoded = parameters
            .map { "\($0.key): \($0.value.graphEncoded())" }
            .sorted()
            .joined(separator: ", ")
        
        return "(\(parametersEncoded))"
    }
    
    public var description: GraphQLStatement {
        return encoded
    }
    
    public static func +(lhs: Parameters, rhs: Parameters) -> Parameters {
        let contents = lhs.parameters.merging(rhs.parameters) { (_, new) in new }
        return Parameters(contents)
    }
}
