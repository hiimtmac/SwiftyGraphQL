//
//  Parameters.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-24.
//  Copyright © 2018 hiimtmac. All rights reserved.
//

import Foundation

public struct Parameters {
    var parameters: [String: ParameterEncoded?]
    
    public init(_ parameters: [String: ParameterEncoded?]) {
        self.parameters = parameters
    }
    
    public var statement: GraphQLStatement {
        guard !parameters.isEmpty else { return "" }
        let parametersEncoded = parameters
            .map { "\($0.key): \($0.value.graphEncoded())" }
            .sorted()
            .joined(separator: ", ")
        
        return "(\(parametersEncoded))"
    }
    
    public static func +(lhs: Parameters, rhs: Parameters) -> Parameters {
        let contents = lhs.parameters.merging(rhs.parameters) { (_, new) in new }
        return Parameters(contents)
    }
    
    public mutating func set(_ parameters: [String: ParameterEncoded?]) {
        for parameter in parameters {
            self.set(key: parameter.key, value: parameter.value)
        }
    }
    
    public mutating func set(key: String, value: ParameterEncoded?) {
        self.parameters[key] = value
    }
}
