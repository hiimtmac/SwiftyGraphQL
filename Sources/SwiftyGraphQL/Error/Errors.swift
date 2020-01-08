//
//  Errors.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-04-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public struct GraphQLErrors: Decodable {
    public let errors: [GraphQLError]
    
    public init(errors: [GraphQLError]) {
        self.errors = errors
    }
    
    public init?(errors: [GraphQLError]?) {
        guard let errors = errors else { return nil }
        self.errors = errors
    }
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
            return "Multiple GraphQL© query/mutation errors."
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
