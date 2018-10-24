//
//  GraphQLError.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-24.
//  Copyright © 2018 hiimtmac. All rights reserved.
//

import Foundation

public struct GraphQLError: Decodable {
    public let message: String
    public let locations: [Location]?
    public let fields: [String]?
    
    public struct Location: Decodable, CustomStringConvertible {
        let line: Int
        let column: Int
        
        public var description: String {
            return "Ln: \(line) / Col: \(column)"
        }
    }
}

extension GraphQLError: Error {}

extension GraphQLError: LocalizedError {
    public var errorDescription: String? {
        return "Unrecoverable GraphQL© query/mutation: \(message)"
    }
    
    public var failureReason: String? {
        return "A GraphQL© query/mutation has been incorrectly constructed."
    }
    
    public var recoverySuggestion: String? {
        guard let locations = locations, let fields = fields else { return nil }
        return "Locations: \(locations.map({$0.description}).joined(separator: ", ")) | Fields: \(fields.map({$0}).joined(separator: ", "))"
    }
}
