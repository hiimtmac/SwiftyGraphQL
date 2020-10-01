//
//  File.swift
//  
//
//  Created by Taylor McIntyre on 2020-09-29.
//

import Foundation

public struct Serializer {
    public var graphQL: String
    public var fragments: [String: GQLFragment]
    public var variables: [String: GQLVariable]
    
    public init() {
        self.graphQL = ""
        self.fragments = [:]
        self.variables = [:]
    }
    
    mutating func write(variable: GQLVariable) {
        variables[variable.name] = variable
    }
    
    mutating func write(_ graphQL: String) {
        self.graphQL += graphQL
    }
    
    mutating func write(fragment: GQLFragment) {
        fragments[fragment.name] = fragment
    }
    
    mutating func writeSpace() {
        self.write(" ")
    }
    
    @discardableResult
    mutating func pop() -> Character? {
        self.graphQL.popLast()
    }
}
