//
//  Errors.swift
//  SwiftyGraphQL
//
//  Created by Taylor McIntyre on 2019-04-04.
//  Copyright © 2019 hiimtmac. All rights reserved.
//

import Foundation

public struct GQLErrorSet: Decodable {
    public let errors: [GQLError]
    
    public init(errors: [GQLError]) {
        self.errors = errors
    }
    
    public init?(errors: [GQLError]?) {
        guard let errors = errors else { return nil }
        self.errors = errors
    }
}

extension GQLErrorSet: Error {}
extension GQLErrorSet: LocalizedError {
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
