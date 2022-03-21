// Serializer.swift
// Copyright © 2022 hiimtmac

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
        self.variables[variable.name] = variable
    }

    mutating func write(_ graphQL: String) {
        self.graphQL += graphQL
    }

    mutating func write(fragment: GQLFragment) {
        self.fragments[fragment.name] = fragment
    }

    mutating func writeSpace() {
        self.write(" ")
    }

    @discardableResult
    mutating func pop() -> Character? {
        self.graphQL.popLast()
    }
}
