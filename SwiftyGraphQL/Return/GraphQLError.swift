//
//  GraphQLError.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2018-10-24.
//  Copyright © 2018 hiimtmac. All rights reserved.
//

import Foundation

public struct GraphQLErrors: Decodable {
    public let errors: [GraphQLError]
}

extension GraphQLErrors: Error {}
extension GraphQLErrors: LocalizedError {
    public var errorDescription: String? {
        if errors.count == 1 {
            return errors.first?.localizedDescription
        } else {
            return "Multiple unrecoverable GraphQL© queries/mutations"
        }
    }
    
    public var failureReason: String? {
        if errors.count == 1 {
            return errors.first?.failureReason
        } else {
            return "Multiple GraphQL© queries/mutations have been incorrectly constructed."
        }
    }
    
    public var recoverySuggestion: String? {
        if errors.count == 1 {
            return errors.first?.recoverySuggestion
        } else {
            return nil
        }
    }
}

public struct GraphQLError: Decodable {
    public let message: String
    public let locations: [Location]?
    public let fields: [String]?
    
    public struct Location: Decodable {
        let line: Int
        let column: Int
        
        public var location: String {
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
        return "Locations: \(locations.map({$0.location}).joined(separator: ", ")) | Fields: \(fields.map({$0}).joined(separator: ", "))"
    }
}
