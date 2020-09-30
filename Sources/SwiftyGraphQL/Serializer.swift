//
//  File.swift
//  
//
//  Created by Taylor McIntyre on 2020-09-29.
//

import Foundation

public struct Serializer {
    var graphQL: String
    var fragments: [String: GQLFragment]
    var variables: [String: GQLVariable]
    
    init() {
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
